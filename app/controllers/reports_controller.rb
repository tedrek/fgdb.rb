class ReportsController < ApplicationController

  layout :report_layout_choice
  def report_layout_choice
    case action_name
    when /report$/ then with_sidebar
    else                'reports_form.rhtml'
    end
  end

  def income
    @defaults = Conditions.new
  end

  def income_report
    @defaults = Conditions.new
    @defaults.apply_conditions(params[:defaults])
    income_report_init
    @date_range_string = @defaults.to_s
    #:MC: cannot get payment_methods to be included
    donations = Donation.find(:all, :conditions => @defaults.conditions(Donation), :include => [:payments])
    sales = SaleTxn.find(:all, :conditions => @defaults.conditions(SaleTxn), :include => [:payments, :discount_schedule])
    sale_ids = []
    donation_ids = []
    donations.each do |donation|
      donation_ids << donation.id
      add_donation_to_data(donation, @income_data)
    end
    sales.each do |sale|
      sale_ids << sale.id
      add_sale_to_data(sale, @income_data)
    end
    @ranges = {}
    @ranges[:donations] = donation_ids.empty? ? 'n/a' : (donation_ids.min)..(donation_ids.max)
    @ranges[:sales] = sale_ids.empty?         ? 'n/a' : (sale_ids.min)..(sale_ids.max)
  end

  protected

  def income_report_init
    methods = PaymentMethod.find_all
    method_names = methods.map {|m| m.description}
    @columns = Hash.new( method_names.insert(2, 'till total').insert(-2, 'total real').insert(-1, 'total') )
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
      "#{SaleTxn.table_name}.created_at >= ? AND #{SaleTxn.table_name}.created_at < ?",
      start_date, end_date
    ], [
      "#{Donation.table_name}.created_at >= ? AND #{Donation.table_name}.created_at < ?",
      start_date, end_date
    ]
  end

  def add_donation_to_data(donation, income_data)
    totals = income_data[:grand_totals]
    required = donation.reported_required_fee
    #:MC: no business rules for what order to evaluate these?
    donation.payments.each {|payment|
      column = income_data[:donations][PaymentMethod.descriptions[payment.payment_method_id]]
      fees = 0
      voluntary = 0
      if required <= 0
        voluntary = payment.amount
      elsif required > payment.amount
          required -= payment.amount
          fees = payment.amount
      else
        fees = required
        required = 0
        voluntary = payment.amount - fees
      end

      if payment.payment_method_id != PaymentMethod.invoice.id
        income_data[:donations]['total real']['fees'] += fees
        income_data[:donations]['total real']['voluntary'] += voluntary
        income_data[:donations]['total real']['subtotals'] += payment.amount
        totals['total real']['total'] += payment.amount
      end

      if( (payment.payment_method_id == PaymentMethod.cash.id) ||
          (payment.payment_method_id == PaymentMethod.check.id) )
        income_data[:donations]['till total']['fees'] += fees
        income_data[:donations]['till total']['voluntary'] += voluntary
        income_data[:donations]['till total']['subtotals'] += payment.amount
        totals['till total']['total'] += payment.amount
      end

      income_data[:donations]['total']['fees'] += fees
      income_data[:donations]['total']['voluntary'] += voluntary
      income_data[:donations]['total']['subtotals'] += payment.amount
      column['fees'] += fees
      column['voluntary'] += voluntary
      column['subtotals'] += payment.amount
      totals[PaymentMethod.descriptions[payment.payment_method_id]]['total'] += payment.amount
      totals['total']['total'] += payment.amount
    }
  end

  def add_sale_to_data(sale, income_data)
    totals = income_data[:grand_totals]
    #:MC: no business rules for what order to evaluate these?
    sale.payments.each {|payment|
      column = income_data[:sales][PaymentMethod.descriptions[payment.payment_method_id]]
      column[sale.discount_schedule.name] += payment.amount
      column['subtotals'] += payment.amount
      if payment.payment_method_id != PaymentMethod.invoice.id
        income_data[:sales]['total real'][sale.discount_schedule.name] += payment.amount
        income_data[:sales]['total real']['subtotals'] += payment.amount
        totals['total real']['total'] += payment.amount
      end
      if( (payment.payment_method_id == PaymentMethod.cash.id) ||
          (payment.payment_method_id == PaymentMethod.check.id) )
        income_data[:sales]['till total'][sale.discount_schedule.name] += payment.amount
        income_data[:sales]['till total']['subtotals'] += payment.amount
        totals['till total']['total'] += payment.amount
      end
      income_data[:sales]['total'][sale.discount_schedule.name] += payment.amount
      income_data[:sales]['total']['subtotals'] += payment.amount
      totals['total']['total'] += payment.amount
      totals[PaymentMethod.descriptions[payment.payment_method_id]]['total'] += payment.amount
    }
  end

end
