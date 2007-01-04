class ReportsController < ApplicationController

  layout :report_layout_choice
  def report_layout_choice
    case action_name
    when /report$/ then 'with_sidebar.rhtml'
    else                'reports_form.rhtml'
    end
  end

  def income
    @date_types = ['daily', 'monthly', 'arbitrary']
    date_choice_init
  end

  def select_date_type
    date_choice_init
    render :update do |page|
      #:MC: scrub this data first?
      page.replace_html "date_choice", :partial => params[:date_type] + "_income"
    end
  end

  def income_report
    income_report_init
    @date_range_string, conditions = determine_date_range
    donations = Donation.find(:all, :conditions => conditions)
    sales = SaleTxn.find(:all, :conditions => conditions)
    totals = @income_data[:grand_totals]
    donations.each do |donation|
      next unless( (donation.money_tendered > 0) and ((donation.reported_suggested_fee + donation.reported_required_fee) > 0) )
      if donation.txn_complete
        column = @income_data[:donations][donation.payment_method.description]
        if donation.money_tendered <= donation.reported_required_fee
          column['fees'] += donation.money_tendered
          @income_data[:donations]['total real']['fees'] += donation.money_tendered
        else
          column['fees'] += donation.reported_required_fee
          @income_data[:donations]['total real']['fees'] += donation.reported_required_fee
          column['voluntary'] += (donation.money_tendered - donation.reported_required_fee)
          @income_data[:donations]['total real']['voluntary'] += (donation.money_tendered - donation.reported_required_fee)
        end
        @income_data[:donations]['total real']['subtotals'] += donation.money_tendered
        column['subtotals'] += donation.money_tendered
        totals[donation.payment_method.description]['total'] += donation.money_tendered
        totals['total real']['total'] += donation.money_tendered
      else
        @income_data[:donations]['invoiced']['fees'] += donation.reported_required_fee
        @income_data[:donations]['invoiced']['voluntary'] += donation.reported_suggested_fee
        @income_data[:donations]['invoiced']['subtotals'] += donation.reported_suggested_fee + donation.reported_required_fee
        totals['invoiced']['total'] += donation.reported_suggested_fee + donation.reported_required_fee
      end
    end
    sales.each do |sale|
      next unless( (sale.money_tendered > 0) or (sale.reported_amount_due > 0) )
      if sale.txn_complete
        column = @income_data[:sales][sale.payment_method.description]
        column[sale.discount_schedule.name] += sale.money_tendered
        @income_data[:sales]['total real'][sale.discount_schedule.name] += sale.money_tendered
        column['subtotals'] += sale.money_tendered
        @income_data[:sales]['total real']['subtotals'] += sale.money_tendered
        totals[sale.payment_method.description]['total'] += sale.money_tendered
        totals['total real']['total'] += sale.money_tendered
      else
        @income_data[:sales]['invoiced'][sale.discount_schedule.name] += sale.reported_amount_due
        @income_data[:sales]['invoiced']['subtotals'] += sale.reported_amount_due
        totals['invoiced']['total'] += sale.reported_amount_due
      end
    end
  end

  protected

  def date_choice_init
    @defaults = Object.new
    def @defaults.date
      Date.today
    end
    def @defaults.month
      Date.today
    end
    def @defaults.year
      Date.today - (256*2)
    end
    def @defaults.method_missing(*args)
      nil
    end
  end

  def income_report_init
    methods = PaymentMethod.find_all
    method_names = methods.map {|m| m.description}
    @columns = Hash.new( method_names + ['total real', 'invoiced'] )
    @width = @columns[nil].length
    @rows = {}
    @rows[:donations] = ['voluntary', 'fees', 'subtotals']
    discount_types = DiscountSchedule.find_all.map {|d_s| d_s.name}
    @rows[:sales] = discount_types << 'subtotals'
    @rows[:grand_totals] = ['total']
    @sections = [:donations, :sales, :grand_totals]

    @income_data = {}
    @income_data[:donations] = {}
    @income_data[:sales] = {}
    @income_data[:grand_totals] = {}

    @sections.each do |section|
     @columns[section].each do |method|
        @income_data[section][method] ||= Hash.new(0.0)
      end
    end
  end

  def determine_date_range
    if params[:defaults][:date]
      date = Date.parse(params[:defaults][:date])
      if date == Date.today
        desc = "today (#{date})"
        start_date = date
        end_date = date + 1
      else
        desc = start_date = date
        end_date = date + 1
      end
    elsif params[:defaults][:start_date] && params[:defaults][:end_date]
      start_date = Date.parse(params[:defaults][:start_date])
      end_date = Date.parse(params[:defaults][:end_date])
      desc = "from #{start_date} to #{end_date}"
    elsif params[:defaults][:month]
      year = (params[:defaults][:year] || Date.today.year).to_i
      start_date = Time.local(year, params[:defaults][:month], 1)
      if params[:defaults][:month].to_i == 12
        month = 1
      else
        month = 1 + params[:defaults][:month].to_i
      end
      end_date = Time.local(year + 1, month, 1)
      desc = "%s, %i" % [ Date::MONTHNAMES[start_date.month], year ]
    end
    return desc, [
      "created_at >= ? AND created_at < ?",
      start_date, end_date
    ]
  end

end
