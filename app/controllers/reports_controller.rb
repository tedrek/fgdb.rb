class ReportsController < ApplicationController

  layout :report_layout_choice
  def report_layout_choice
    case action_name
    when /report$/ then 'reports_display.rhtml'
    else                'reports_form.rhtml'
    end
  end

  def income
  end

  def income_report
    income_report_init
    @date_range_string = "today (#{Date.today})"
    donations = Donation.find(:all, :conditions => [
                                "created_at >= ?",
                                Date.today
                              ])
    sales = SaleTxn.find(:all, :conditions => [
                           "created_at >= ?",
                           Date.today
                         ])
    totals = @income_data[:grand_totals]
    donations.each do |donation|
      next unless donation.money_tendered > 0
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
      next unless sale.amount_due > 0
      column_to_effect = @income_data[:sales][sale.payment_method.description]
      column_to_effect['retail'] += sale.amount_due
      column_to_effect['subtotals'] += sale.amount_due
      @income_data[:sales]['total real']['retail'] += sale.amount_due
      @income_data[:sales]['total real']['subtotals'] += sale.amount_due
      totals[sale.payment_method.description]['total'] += sale.amount_due
      totals['total real']['total'] += sale.amount_due
    end
  end

  protected

  def income_report_init
    methods = PaymentMethod.find_all
    method_names = methods.map {|m| m.description}
    @columns = Hash.new( method_names + ['total real'] )
    @columns[:donations] = method_names + ['total real', 'invoiced']
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
end
