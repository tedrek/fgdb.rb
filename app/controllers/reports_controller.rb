class ReportsController < ApplicationController

  layout :report_layout_choice
  def report_layout_choice
    case action_name
    when /report$/ then with_sidebar
    else                'reports_form.rhtml'
    end
  end

  #####################
  ### Gizmos report ###
  #####################

  def gizmos
    @defaults = Conditions.new
  end

  def gizmos_report
    @defaults = Conditions.new
    @defaults.apply_conditions(params[:defaults])
    @date_range_string = @defaults.to_s
    @gizmo_data = gizmos_report_init
    gizmo_ids = []
    gizmo_events = GizmoEvent.find(:all, :conditions => @defaults.conditions(GizmoEvent),
                                   :include => [:gizmo_type, :gizmo_context])
    gizmo_events.each {|event|
      gizmo_ids << event.id
      add_gizmo_to_data(event, @gizmo_data)
    }
    @range = gizmo_ids.empty? ? 'n/a' : (gizmo_ids.min)..(gizmo_ids.max)
  end

  protected

  TotalGizmoRow = 'all gizmos'
  TotalGizmoCol = 'total flow'

  def gizmos_report_init
    @contexts = GizmoContext.find_all
    context_names = @contexts.map {|context| context.name}.sort
    context_names << TotalGizmoCol
    @types = GizmoType.find_all
    type_names = @types.map {|type| type.description}.sort
    type_names << TotalGizmoRow
    @columns = context_names
    @rows = type_names
    gizmo_data = {}
    @rows.each {|type| gizmo_data[type] = Hash.new(0)}
    gizmo_data
  end

  TotalGizmoModifiers = Hash.new(-1)
  TotalGizmoModifiers['donation'] = 1

  def add_gizmo_to_data(event, data)
    # donations come in.  sales, recycling and disbursements go out.
    modifier = TotalGizmoModifiers[event.gizmo_context.name]
    data[event.gizmo_type.description][event.gizmo_context.name] += ( modifier * event.gizmo_count )
    data[TotalGizmoRow][event.gizmo_context.name] += ( modifier * event.gizmo_count )
    data[event.gizmo_type.description][TotalGizmoCol] += ( modifier * event.gizmo_count )
    data[TotalGizmoRow][TotalGizmoCol] += ( modifier * event.gizmo_count )
  end

  #####################
  ### Income report ###
  #####################

  public

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
    sales = Sale.find(:all, :conditions => @defaults.conditions(Sale), :include => [:payments, :discount_schedule])
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
    @columns = Hash.new( method_names.insert(2, 'till total').insert(-3, 'total real').insert(-1, 'total') )
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

      unless( [PaymentMethod.invoice.id, PaymentMethod.coupon.id].include? payment.payment_method_id )
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
      unless( [PaymentMethod.invoice.id, PaymentMethod.coupon.id].include? payment.payment_method_id )
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
