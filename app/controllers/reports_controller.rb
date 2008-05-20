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
    GizmoEvent.totals(@defaults.conditions(GizmoEvent)).each do |summation|
      add_gizmo_to_data(summation, @gizmo_data)
    end
  end

  protected

  def gizmos_report_init
    @columns = DisbursementType.find(:all).map {|type| [DisbursementType, type.id]}
    @columns += GizmoContext.find(:all).map {|context| [GizmoContext, context.id]}
    @columns << [nil,:total]
    @rows = GizmoType.find(:all).map {|type| type.id}
    @rows << :total
    gizmo_data = {}
    @rows.each {|type| gizmo_data[type] = Hash.new(0)}
    gizmo_data
  end

  def context_tuple(id)
    [GizmoContext, id]
  end

  def disbursement_tuple(id)
    [DisbursementType, id]
  end

  def plus_or_minus(id)
    # donations come in.  sales, recycling and disbursements go out.
    id == GizmoContext.donation.id ? 1 : -1
  end

  def add_gizmo_to_data(summation, data)
    type_id, context_id, disbursement_type_id, count = summation.map {|x| x.to_i}
    count *= plus_or_minus(context_id)
    if context_id == GizmoContext.disbursement.id
      tuple = disbursement_tuple(disbursement_type_id)
      data[type_id][tuple] += count
      data[:total][tuple] += count
    end
    tuple = context_tuple(context_id)
    data[type_id][tuple] += count
    data[:total][tuple] += count
    data[type_id][[nil, :total]] += count
    data[:total][[nil, :total]] += count
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
    ranges = {:sales => {:min => 1<<64, :max => 0},
               :donations => {:min => 1<<64, :max => 0}
    }
    Donation.totals(@defaults.conditions(Donation)).each do |summation|
      add_donation_summation_to_data(summation, @income_data, ranges)
    end
    Sale.totals(@defaults.conditions(Sale)).each do |summation|
      add_sale_summation_to_data(summation, @income_data, ranges)
    end

    @ranges = {}
    [:sales, :donations].each do |x|
      @ranges[x] = "#{ranges[x][:min]}..#{ranges[x][:max]}"
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
    @income_data[:donations][:range] = {:min=>1<<64, :max=>0}
    @income_data[:sales] = {}
    @income_data[:sales][:range] = {:min=>1<<64, :max=>0}
    @income_data[:grand_totals] = {}

    @sections.each do |section|
     @columns[section].each do |method|
        @income_data[section][method] ||= Hash.new(0.0)
      end
    end
  end

  def add_donation_summation_to_data(summation, income_data, ranges)
    payment_method_id, amount_cents, required_cents, suggested_cents, count, mn, mx =
      summation[0..6].map {|c| c.to_i}
    return unless payment_method_id and payment_method_id != 0

    ranges[:donations][:min] = [ranges[:donations][:min], mn].min
    ranges[:donations][:max] = [ranges[:donations][:max], mx].max

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

  def add_sale_summation_to_data(summation, income_data, ranges)
    payment_method_id, discount_schedule_id, amount_cents, count, mn, mx =
      summation[0..5].map {|c| c.to_i}
    return unless payment_method_id and payment_method_id != 0

    discount_schedule = DiscountSchedule.find(discount_schedule_id)

    ranges[:sales][:min] = [ranges[:sales][:min], mn].min
    ranges[:sales][:max] = [ranges[:sales][:max], mx].max
      
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
    @defaults.date_range_enabled = "false"
    @defaults.contact_enabled = "true"
  end

  def volunteers_report
    @defaults = Conditions.new
    params[:defaults][:contact_id] = params[:contact][:id] if params[:contact]
    @defaults.apply_conditions(params[:defaults])
    @date_range_string = @defaults.to_s
    @tasks = VolunteerTask.find_by_conditions(@defaults.conditions(VolunteerTask))
    @sections = [:community_service_type, :volunteer_task_type]
    @data = volunteer_report_for(@tasks, @sections)
  end

  protected

  def volunteer_report_for(tasks, sections)
    data = {}
    sections.each {|section|
      data[section] = {}
      eval(Inflector.classify(section)).find(:all).each {|type|
        data[section][type.description] = 0.0
      }
      data[section]['Total'] = 0.0
      data[section]['(none)'] = 0.0
    }
    tasks.each {|task|
      add_task_to_data(task, sections, data)
    }
    return data
  end

  def add_task_to_data(task, sections, data)
    i=1
    sections.each do |section|
      data[section][(task[i] || '(none)')] += task[0].to_f
      data[section]["Total"] ||= 0.0
      data[section]["Total"] += task[0].to_f
      i += 1
    end
  end

end
