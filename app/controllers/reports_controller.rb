class ReportsController < ApplicationController

  layout :report_layout_choice
  def report_layout_choice
    case action_name
    when /report$/ then 'reports_display.rhtml'
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
      next unless( (donation.money_tendered > 0) and (donation.txn_complete) )
      if donation.txn_complete
        column_to_effect = @income_data[:donations][donation.payment_method.description]
        if donation.money_tendered <= donation.reported_required_fee
          column_to_effect['fees'] += donation.money_tendered
          @income_data[:donations]['total real']['fees'] += donation.money_tendered
        else
          column_to_effect['fees'] += donation.reported_required_fee
          @income_data[:donations]['total real']['fees'] += donation.reported_required_fee
          column_to_effect['voluntary'] += (donation.money_tendered - donation.reported_required_fee)
          @income_data[:donations]['total real']['voluntary'] += (donation.money_tendered - donation.reported_required_fee)
        end
        @income_data[:donations]['total real']['subtotals'] += donation.money_tendered
        column_to_effect['subtotals'] += donation.money_tendered
        totals[donation.payment_method.description]['total'] += donation.money_tendered
        totals['total real']['total'] += donation.money_tendered
      else
        @income_data[:donations]['invoiced']['fees'] += donations.reported_required_fee
        @income_data[:donations]['invoiced']['voluntary'] += donations.reported_suggested_fee
        @income_data[:donations]['invoiced']['subtotals'] += donations.reported_suggested_fee + donations.reported_required_fee
      end
    end
    sales.each do |sale|
      next unless( (sale.money_tendered > 0) and (sale.txn_complete) )
      if sale.txn_complete
        column_to_effect = @income_data[:sales][sale.payment_method.description]
        column_to_effect[sale.bulk ? 'wholesale' : 'retail'] += sale.reported_amount_due
        @income_data[:sales]['total real'][sale.bulk ? 'wholesale' : 'retail'] += sale.reported_amount_due
        column_to_effect['subtotals'] += sale.reported_amount_due
        @income_data[:sales]['total real']['subtotals'] += sale.reported_amount_due
        totals[sale.payment_method.description]['total'] += sale.reported_amount_due
        totals['total real']['total'] += sale.reported_amount_due
      else
        @income_data[:sales]['invoiced'][sale.bulk ? 'wholesale' : 'retail'] += sale.reported_amount_due
        @income_data[:sales]['invoiced']['subtotals'] += sale.reported_amount_due
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
      Date.today
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
    @rows[:sales] = ['retail', 'wholesale', 'subtotals']
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
        return "today (#{date})", [
          "created_at >= ?",
          date
        ]
      else
        return date, [
          "created_at >= ? AND created_at < ?",
          date, date + 1
        ]
      end
    elsif params[:defaults][:start_date] && params[:defaults][:end_date]
      start_date = Date.parse(params[:defaults][:start_date])
      end_date = Date.parse(params[:defaults][:end_date])
      return "from #{start_date} to #{end_date}", [
          "created_at >= ? AND created_at < ?",
          start_date, end_date
        ]
    elsif params[:defaults][:month]
      year = (params[:defaults][:year] || Date.today.year).to_i
      month_start = Time.local(year, params[:defaults][:month], 1)
      if params[:defaults][:month].to_i == 12
        month = 1
        year += 1
      else
        month = 1 + params[:defaults][:month].to_i
      end
      month_end = Time.local(year, month, 1)
      return "from #{month_start.to_date} to #{month_end.to_date - 1}", [
          "created_at >= ? AND created_at < ?",
          month_start, month_end
        ]
    end
  end

end
