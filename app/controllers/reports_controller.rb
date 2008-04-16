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
    @contexts = GizmoContext.find(:all)
    context_names = @contexts.map {|context| context.name}.sort
    context_names << TotalGizmoCol
    @types = GizmoType.find(:all)
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
    @income_data = {}
    income_report_init #:MC: modifies @income_data
    @date_range_string = @defaults.to_s
    @ranges = {}
    Donation.totals(@defaults.conditions(Donation)).each do |summation|
      add_donation_to_data(summation, @income_data)
    end
    Sale.totals(@defaults.conditions(Sale)).each do |summation|
      add_sale_to_data(summation, @income_data)
    end
  end

  protected

  def income_report_init
    methods = PaymentMethod.find(:all)
    method_names = methods.map {|m| m.description}
    @columns = Hash.new( method_names.insert(2, 'till total').insert(-3, 'total real').insert(-1, 'total') )
    @width = @columns[nil].length
    @rows = {}
    @rows[:donations] = ['fees', 'suggested', 'subtotals']
    discount_types = DiscountSchedule.find(:all).map {|d_s| d_s.name}.sort
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

  def add_donation_to_data(summation, income_data)
    payment_method_id, amount_cents, required_cents, suggested_cents, count =
      summation[0..4].map {|c| c.to_i}
    return unless payment_method_id and payment_method_id != 0

    totals = income_data[:grand_totals]

    column = income_data[:donations][PaymentMethod.descriptions[payment_method_id]]
    fees_cents = 0
    suggested_cents = 0
    if required_cents <= 0
      suggested_cents = amount_cents
    elsif required_cents > amount_cents
      required_cents -= amount_cents
      fees_cents = amount_cents
    else
      fees_cents = required_cents
      required_cents = 0
      suggested_cents = amount_cents - fees_cents
    end

    if payment_method_id != PaymentMethod.invoice.id
      income_data[:donations]['total real']['fees'] += fees_cents
      income_data[:donations]['total real']['suggested'] += suggested_cents
      income_data[:donations]['total real']['subtotals'] += amount_cents
      totals['total real']['total'] += amount_cents
    end

    if( (payment_method_id == PaymentMethod.cash.id) ||
        (payment_method_id == PaymentMethod.check.id) )
      income_data[:donations]['till total']['fees'] += fees_cents
      income_data[:donations]['till total']['suggested'] += suggested_cents
      income_data[:donations]['till total']['subtotals'] += amount_cents
      totals['till total']['total'] += amount_cents
    end

    income_data[:donations]['total']['fees'] += fees_cents
    income_data[:donations]['total']['suggested'] += suggested_cents
    income_data[:donations]['total']['subtotals'] += amount_cents
    column['fees'] += fees_cents
    column['suggested'] += suggested_cents
    column['subtotals'] += amount_cents
    totals[PaymentMethod.descriptions[payment_method_id]]['total'] += amount_cents
    totals['total']['total'] += amount_cents
  end

  def add_sale_to_data(summation, income_data)
    payment_method_id, discount_schedule_id, amount_cents, count =
      summation[0..3].map {|c| c.to_i}
    return unless payment_method_id and payment_method_id != 0
    discount_schedule = DiscountSchedule.find(discount_schedule_id)

    totals = income_data[:grand_totals]
    column = income_data[:sales][PaymentMethod.descriptions[payment_method_id]]
    column[discount_schedule.name] += amount_cents
    column['subtotals'] += amount_cents
    if PaymentMethod.is_money_method?(payment_method_id)
      income_data[:sales]['total real'][discount_schedule.name] += amount_cents
      income_data[:sales]['total real']['subtotals'] += amount_cents
      totals['total real']['total'] += amount_cents
    end
    if PaymentMethod.is_till_method?(payment_method_id)
      income_data[:sales]['till total'][discount_schedule.name] += amount_cents
      income_data[:sales]['till total']['subtotals'] += amount_cents
      totals['till total']['total'] += amount_cents
    end
    income_data[:sales]['total'][discount_schedule.name] += amount_cents
    income_data[:sales]['total']['subtotals'] += amount_cents
    totals['total']['total'] += amount_cents
    totals[PaymentMethod.descriptions[payment_method_id]]['total'] += amount_cents
  end

  ########################
  ### Volunteer report ###
  ########################

  public

  def volunteers
    @defaults = Conditions.new
    @defaults.limit_type = "contact"
  end

  def volunteers_report
    @defaults = Conditions.new
    if params[:filter_contact] and params[:filter_contact][:query]
      params[:defaults][:contact_id] = params[:filter_contact][:query]
    end
    @defaults.apply_conditions(params[:defaults])
    @date_range_string = @defaults.to_s(has_role_or_is_me?((params[:defaults][:contact_id]||0), "ROLE_VOLUNTEER_MANAGER"))
    @tasks = VolunteerTask.find(:all, :conditions => @defaults.conditions(VolunteerTask),
                                :include => [:volunteer_task_type, :community_service_type])
    @sections = [:volunteer_task_type, :community_service_type]
    @data = volunteer_report_for(@tasks, @sections)
  end

  protected

  def volunteer_report_for(tasks, sections)
    data = {}
    sections.each {|section|
      data[section] = {}
      eval(Inflector.classify(section)).find(:all).each {|type|
        data[section][type.display_name] = 0.0
      }
      data[section]['Total'] = 0.0
      data[section]['(none)'] = 0.0
    }
    tasks.each {|task|
      sections.each {|section|
        add_task_to_data(task, section, data)
      }
    }
    return data
  end

  def add_task_to_data(task, section, data)
    type = task.send(section)
    if type
      type = type.display_name
    else
      type = '(none)'
    end
    data[section][type] += task.duration
    while type.respond_to?(:parent) do
      type = type.parent
      data[section][type] += task.duration
    end
    data[section]["Total"] ||= 0.0
    data[section]["Total"] += task.duration
  end

end
