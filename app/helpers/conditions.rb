class Conditions < ConditionsBase
  DATES = %w[
      created_at recycled_at disbursed_at received_at
      worked_at bought_at date_performed donated_at occurred_at
      shift_date date
  ]

  CONDS = (%w[
      id contact_type needs_attention anonymous unresolved_invoices
      payment_method payment_amount gizmo_type_id gizmo_category_id covered
      postal_code city phone_number contact volunteer_hours email
      flagged system contract created_by cashier_created_by extract
      empty disbursement_type_id store_credit_id organization
      can_login role action worker contribution serial_number job
      volunteer_task_type weekday sked roster effective_at cancelled
      needs_checkin assigned attendance_type worker_type
      effective_at schedule type store_credit_redeemed
    ] + DATES).uniq

  CHECKBOXES = %w[ cancelled assigned covered organization ]

  for i in CONDS
    attr_accessor (i + "_enabled").to_sym
    attr_accessor (i + "_excluded").to_sym
  end

  for i in DATES
    attr_accessor (i + '_date').to_sym, (i + '_date_type').to_sym, (i + '_start_date').to_sym, (i + '_end_date').to_sym, (i + '_month').to_sym, (i + '_year').to_sym, (i + '_quarter').to_sym
  end

  attr_accessor :cancelled

  attr_accessor :volunteer_task_type_id

  attr_accessor :weekday_id
  attr_accessor :roster_id
  attr_accessor :sked_id

  attr_accessor :schedule_id, :schedule_which_way

  attr_accessor :effective_at

  attr_accessor :worker_id

  attr_accessor :job_id

  attr_accessor :created_by, :cashier_created_by

  attr_accessor :covered

  attr_accessor :serial_number

  attr_accessor :contact_id

  attr_accessor :contract_id

  attr_accessor :payment_method_id

  attr_accessor :id

  attr_accessor :system_id

  attr_accessor :needs_attention

  attr_accessor :anonymous

  attr_accessor :unresolved_invoices

  attr_accessor :gizmo_type_id

  attr_accessor :gizmo_category_id

  attr_accessor :payment_amount_type, :payment_amount_exact, :payment_amount_low, :payment_amount_high, :payment_amount_ge, :payment_amount_le

  attr_accessor :contact_type

  attr_accessor :is_organization

  attr_accessor :city, :postal_code, :phone_number, :email

  attr_accessor :volunteer_hours_type, :volunteer_hours_exact, :volunteer_hours_low, :volunteer_hours_high, :volunteer_hours_ge, :volunteer_hours_le

  attr_accessor :extract_type, :extract_value, :extract_field

  attr_accessor :disbursement_type_id

  attr_accessor :store_credit_id

  attr_accessor :attendance_type_id

  attr_accessor :worker_type_id

  attr_accessor :role

  attr_accessor :action
  attr_accessor :type

  attr_accessor :assigned

  def init_callback
    @payment_method_id = PaymentMethod.cash.id
    @assigned = true
  end

  def schedule_conditions(klass)
    in_clause = "(-1)"
    s = Schedule.find_by_id(@schedule_id)
    if s
      if @schedule_which_way == 'Solo'
        in_clause = s.in_clause_solo
      elsif @schedule_which_way == 'Solo + root'
        in_clause = s.in_clause_root_plus
      else # @schedule_which_way == 'Family'
        in_clause = s.in_clause_family
      end
    end
    in_clause += " AND (NOT actual) AND (shift_date IS NULL) AND ('#{Date.today}' BETWEEN shifts.effective_date AND shifts.ineffective_date OR shifts.ineffective_date IS NULL)" if klass == Shift
    return ["#{klass.table_name}.schedule_id IN #{in_clause}"]
  end

  def store_credit_redeemed_conditions(klass)
    raise unless klass == GizmoReturn
    return ["#{klass.table_name}.id IN (SELECT gizmo_return_id FROM store_credits WHERE gizmo_return_id IS NOT NULL AND (payment_id IS NOT NULL OR id IN (SELECT return_store_credit_id FROM gizmo_events WHERE return_store_credit_id IS NOT NULL)))"]
  end

  def effective_at_conditions(klass)
    ["(#{klass.table_name}.effective_at IS NULL OR #{klass.table_name}.effective_at <= ?) AND (#{klass.table_name}.ineffective_at IS NULL OR #{klass.table_name}.ineffective_at > ?)", @effective_at, @effective_at]
  end

  def worker_type_conditions(klass)
    search_date = klass.table_name + "." + klass.conditions_date_field
    search_worker_id = klass.table_name + ".worker_id"
    ["(SELECT worker_type_id FROM workers_worker_types WHERE workers_worker_types.worker_id = #{search_worker_id} AND (#{search_date} >= workers_worker_types.effective_on OR workers_worker_types.effective_on IS NULL) AND (#{search_date} <= workers_worker_types.ineffective_on OR workers_worker_types.ineffective_on IS NULL) LIMIT 1) = ?", @worker_type_id]
  end

  def worker_conditions(klass)
    return ["worker_id IN (?)", @worker_id]
  end

  def job_conditions(klass)
    return ["job_id IN (?)", @job_id]
  end

  def empty_conditions(klass)
    return ["1=1"]
  end

  def cancelled_conditions(klass)
    if @cancelled == 1
      return ["1=1"]
    else
      return ["(attendance_type_id IS NULL OR attendance_types.cancelled = false OR attendance_types.cancelled IS NULL)"]
    end
  end

  def attendance_type_conditions(klass)
    return ["attendance_type_id = ?", @attendance_type_id]
  end

  def needs_checkin_conditions(klass)
    return ["attendance_type_id IS NULL"]
  end

  def assigned_conditions(klass)
    if @assigned
      return ["contact_id IS NOT NULL"]
    else
      return ["contact_id IS NULL"]
    end
  end

  def join_conditions(conds_a, conds_b)
    raise ArgumentError.new("'#{conds_a}' is empty") if conds_a.empty?
    raise ArgumentError.new("'#{conds_b}' is empty") if conds_b.empty?
    return [
            conds_a[0].to_s +
            (conds_a[0].empty? ? '' : ' AND ') +
            conds_b[0].to_s
           ] + conds_a[1..-1] + conds_b[1..-1]
  end

  def can_login_conditions(klass)
    ["#{klass.table_name}.id IN (SELECT contact_id FROM users WHERE can_login = 't')"]
  end

  def role_conditions(klass)
    ["#{klass.table_name}.id IN (SELECT contact_id FROM users WHERE can_login = 't' AND id IN (SELECT user_id FROM roles_users WHERE role_id = ?))", @role]
  end

  def action_conditions(klass)
    klass = BuilderTask if klass == SpecSheet
    ["#{klass.table_name}.action_id = ?", @action]
  end

  def type_conditions(klass)
    klass = SpecSheet if klass == BuilderTask
    ["#{klass.table_name}.type_id = ?", @type]
  end

  def covered_conditions(klass)
    ["gizmo_events.covered = ?", @covered != 0]
  end

  def payment_amount_conditions(klass)
    # the to_s is required below because when a value of "6" is passed in
    # it is magically made into a Fixnum so the to_cents blows up
    # not sure where this magic comes from
    case @payment_amount_type
    when 'between'
      return ["payments.amount_cents BETWEEN ? AND ?",
              @payment_amount_low.to_s.to_cents,
              @payment_amount_high.to_s.to_cents]
    when '>='
      return ["payments.amount_cents >= ?", @payment_amount_ge.to_s.to_cents]
    when '<='
      return ["payments.amount_cents <= ?", @payment_amount_le.to_s.to_cents]
    when 'exact'
      return ["payments.amount_cents = ?", @payment_amount_exact.to_s.to_cents]
    end
  end

  def extract_conditions(klass)
    return ["EXTRACT( #{@extract_type} FROM #{klass.table_name}.#{@extract_field} ) = ?", @extract_value]
  end

  def volunteer_task_type_conditions(klass)
    tbl = klass.table_name
    tbl = "volunteer_shifts" if tbl == "assignments"
    return ["#{tbl}.volunteer_task_type_id = ?", @volunteer_task_type_id]
  end

  def weekday_conditions(klass)
    klass = VolunteerDefaultEvent if klass == VolunteerDefaultShift
    klass = VolunteerDefaultEvent if klass == ResourcesVolunteerDefaultEvent
    klass = VolunteerDefaultEvent if klass == DefaultAssignment
    return ["#{klass.table_name}.weekday_id = ?", @weekday_id]
  end

  def roster_conditions(klass)
    klass = VolunteerShift if klass == Assignment
    klass = VolunteerDefaultShift if klass == DefaultAssignment
    tbl = klass.table_name
    return ["#{tbl}.roster_id = ?", @roster_id]
  end

  def sked_conditions(klass)
    klass = VolunteerShift if klass == Assignment
    klass = VolunteerDefaultShift if klass == DefaultAssignment
    tbl = klass.table_name
    return ["#{tbl}.roster_id IN (SELECT roster_id FROM rosters_skeds WHERE sked_id = ?)", @sked_id]
  end

  def volunteer_hours_conditions(klass)
    first_part = "id IN (SELECT contact_id FROM volunteer_tasks vt JOIN contacts c ON c.id=vt.contact_id GROUP BY 1,c.next_milestone HAVING"
    case @volunteer_hours_type
    when 'between'
      return ["#{first_part} sum(duration) BETWEEN ? AND ?)",
              @volunteer_hours_low,
              @payment_amount_high]
    when '>='
      return ["#{first_part} sum(duration) >= ?)", @volunteer_hours_ge]
    when '<='
      return ["#{first_part} sum(duration) <= ?)", @volunteer_hours_le]
    when 'exact'
      return ["#{first_part} sum(duration) = ?)", @volunteer_hours_exact]
    end
  end

  def contract_conditions(klass)
    if klass == GizmoEvent
      ["(donations.contract_id = ? OR systems.contract_id = ? OR recycling_contract_id = ?)", @contract_id, @contract_id, @contract_id]
    elsif klass == Donation
      ["contract_id = ?", @contract_id]
    else # recyclings and disbursements
      ["(gizmo_events.system_id IN (SELECT id FROM systems WHERE contract_id = ?) OR gizmo_events.recycling_contract_id = ?)", @contract_id, @contract_id]
    end
  end

  def id_conditions(klass)
    klass = SpecSheet if klass == BuilderTask
    return ["#{klass.table_name}.id = ?", @id]
  end

  def postal_code_conditions(klass)
    return ["#{klass.table_name}.postal_code ILIKE '?%'", @postal_code]
  end

  def city_conditions(klass)
    return ["#{klass.table_name}.city ILIKE ?", @city]
  end

  def email_conditions(klass)
    return ["#{klass.table_name}.id IN (SELECT contact_id FROM contact_methods WHERE contact_method_type_id IN (SELECT id FROM contact_method_types WHERE description ILIKE '%email%') AND value ILIKE ?)", @email]
  end

  def phone_number_conditions(klass)
    phone_number = @phone_number.to_s.gsub(/[^[:digit:]]/, "")
    if phone_number.length != 10
      @phone_number = "INVALID PHONE NUMBER(MUST BE 10 DIGITS LONG)...IGNORED"
      return [""]
    end
    phone_number = phone_number.sub(/^(.{3})(.{3})(.{4})$/, "%\\1%\\2%\\3%")
    return ["#{klass.table_name}.id IN (SELECT contact_id FROM contact_methods WHERE contact_method_type_id IN (SELECT id FROM contact_method_types WHERE (description ILIKE '%phone%') OR (description ILIKE '%fax%')) AND value ILIKE ?)", phone_number]
  end

  def contact_type_conditions(klass)
    if klass == Contact
      i = "id"
    else
      i = "contact_id"
    end
    return ["#{klass.table_name}.#{i} IN (SELECT contact_id FROM contact_types_contacts WHERE contact_type_id = ?)", @contact_type]
  end

  def organization_conditions(klass)
    if klass == Contact
      i = "id"
    else
      i = "contact_id"
    end
    return ["#{klass.table_name}.#{i} IN (SELECT id FROM contacts WHERE is_organization = ?)", (@is_organization > 0) ? true : false]
  end

  def needs_attention_conditions(klass)
    return ["#{klass.table_name}.needs_attention = 't'"]
  end

  def anonymous_conditions(klass)
    return ["#{klass.table_name}.postal_code IS NOT NULL AND #{klass.table_name}.contact_id IS NULL"]
  end

  def unresolved_invoices_conditions(klass)
    return ["#{klass.table_name}.invoice_resolved_at IS NULL" +
            " AND payments.payment_method_id = ?",
            PaymentMethod.find_by_description('invoice')
           ]
  end

  def flagged_conditions(klass)
    klass = SpecSheet if klass == BuilderTask
    return ["#{klass.table_name}.flag = 't'"]
  end

  def system_conditions(klass)
    klass = SpecSheet if klass == BuilderTask
    if klass == Sale or klass == Disbursement
      return ["? IN (gizmo_events.system_id)", @system_id]
    else
      return ["#{klass.table_name}.system_id = ?", @system_id]
    end
  end

  def worked_at_conditions(klass)
    a = date_range(VolunteerTask, 'date_performed', 'worked_at')
    b = a[0]
    a[0] = "id IN (SELECT contact_id FROM volunteer_tasks WHERE #{b})"
    a
  end

  def received_at_conditions(klass)
    a = date_range(Disbursement, 'disbursed_at', 'received_at')
    b = a[0]
    a[0] = "id IN (SELECT contact_id FROM disbursements WHERE #{b})"
    a
  end

  def bought_at_conditions(klass)
    a = date_range(Sale, 'created_at', 'bought_at')
    b = a[0]
    a[0] = "id IN (SELECT contact_id FROM sales WHERE #{b})"
    a
  end

  def donated_at_conditions(klass)
    a = date_range(Donation, 'created_at', 'donated_at')
    b = a[0]
    a[0] = "id IN (SELECT contact_id FROM donations WHERE #{b})"
    a
  end

  def date_conditions(klass)
    klass = VolunteerShift if klass == Assignment
    klass = VolunteerEvent if klass == VolunteerShift
    klass = VolunteerEvent if klass == ResourcesVolunteerEvent
    date_range(klass, 'date', 'date')
  end

  def shift_date_conditions(klass)
    date_range(klass, 'shift_date', 'shift_date')
  end

  def occurred_at_conditions(klass)
    date_range(klass, 'occurred_at', 'occurred_at')
  end

  def created_at_conditions(klass)
    date_range(klass, 'created_at', 'created_at')
  end

  def date_performed_conditions(klass)
    date_range(klass, 'date_performed', 'date_performed')
  end

  def recycled_at_conditions(klass)
    date_range(klass, 'recycled_at', 'recycled_at')
  end

  def disbursed_at_conditions(klass)
    date_range(klass, 'disbursed_at', 'disbursed_at')
  end

  def created_by_conditions(klass)
    ["created_by = ?", @created_by]
  end

  def cashier_created_by_conditions(klass)
    ["cashier_created_by = ?", @cashier_created_by]
  end

  # TODO: should this be in conditions_base? and the html part that's
  # in html_helper in conditions_base_helper? YES!
  def date_range(klass, db_field, condition_name)
    field = condition_name
    case eval("@#{field}_date_type")
    when 'daily'
      start_date = Date.parse(eval("@#{field}_date").to_s)
      end_date = start_date + 1
    when 'monthly'
      year = (eval("@#{field}_year") || Date.today.year).to_i
      start_date = Time.local(year, eval("@#{field}_month"), 1)
      if eval("@#{field}_month").to_i == 12
        end_month = 1
        end_year = year + 1
      else
        end_month = 1 + eval("@#{field}_month").to_i
        end_year = year
      end
      end_date = Time.local(end_year, end_month, 1)
    when 'quarterly'
      quarter = eval("@#{field}_quarter")
      year = eval("@#{field}_year")
      start_date = Time.local(year, (quarter * 3) - 2, 1)
      end_year = year
      end_month = (quarter * 3) - 2
      end_month += 3
      if end_month > 12
        end_month -= 12
        end_year += 1
      end
      end_date = Time.local(end_year, end_month, 1)
    when 'yearly'
      year = eval("@#{field}_year")
      start_date = Time.local(year, 1, 1)
      end_date = Time.local(year + 1, 1, 1)
    when 'arbitrary'
      stds = eval("@#{field}_start_date").to_s
      start_date = stds.length == 0 ? nil : Date.parse(stds)
      ends = eval("@#{field}_end_date").to_s
      end_date = ends.length == 0 ? nil : (Date.parse(ends) + 1)
    end
    column_name = db_field
    conds = []
    opts = []
    unless start_date.nil?
      opts << start_date
      conds << "#{klass.table_name}.#{column_name} >= ?"
    end
    unless end_date.nil?
      opts << end_date
      conds << "#{klass.table_name}.#{column_name} < ?"
    end
    return [ conds.join(" AND "),
             *opts ]
  end

  def contact_conditions(klass)
    klass = BuilderTask if klass == SpecSheet
    if klass == GizmoEvent
      return ["(sales.contact_id = ? OR donations.contact_id = ? OR gizmo_returns.contact_id = ? OR disbursements.contact_id = ?)", contact_id, contact_id, contact_id, contact_id] # NOT OR recyclings.contact_id = ?
    else
      return [ "#{klass.table_name}.contact_id = ?", contact_id ]
    end
  end

  def payment_method_conditions(klass)
    if klass.new.respond_to?(:payments)
      return [ "payments.payment_method_id = ?", payment_method_id ]
    else
      return [ "#{klass.table_name}.id IS NULL" ]
    end
  end

  def gizmo_type_id_conditions(klass)
    return ["gizmo_events.gizmo_type_id=?", gizmo_type_id]
  end

  def serial_number_conditions(klass)
    klass = SpecSheet if klass == BuilderTask
    if klass == SpecSheet
      return ["#{klass.table_name}.system_id IN (SELECT id FROM systems WHERE ? IN (system_serial_number, mobo_serial_number, serial_number))", @serial_number]
    elsif klass == DisktestRun
      return ["serial_number = ?", @serial_number]
    else
      raise
    end
  end

  def contribution_conditions(klass)
    return ["(SELECT count(*) from gizmo_events WHERE #{klass.table_name.singularize}_id = #{klass.table_name}.id) = 0"]
  end

  def gizmo_category_id_conditions(klass)
    return ["(SELECT gizmo_category_id FROM gizmo_types WHERE id = gizmo_events.gizmo_type_id) = ?", gizmo_category_id]
  end

  def disbursement_type_id_conditions(klass)
    return ["#{klass.table_name}.disbursement_type_id = ?", disbursement_type_id]
  end

  def store_credit_id_conditions(klass)
    tid = -1
    begin
      tid = StoreChecksum.new_from_checksum(store_credit_id).result
    rescue StoreChecksumException
    end
    if klass == GizmoReturn
      return ["#{klass.table_name}.id IN (SELECT #{klass.table_name.singularize}_id FROM store_credits WHERE id = ?)", tid]
    elsif klass == Sale
      return ["payments.id = (SELECT payment_id FROM store_credits WHERE id = ?)", tid]
    else
      raise NoMethodError
    end
  end

  def some_date_enabled
    DATES.each{|x|
      if eval("@#{x}_enabled") == "true"
        return x
      end
    }
    return false
  end

  def contact
    if contact_id && !contact_id.to_s.empty?
      if( (! @contact) || (contact_id != @contact.id) )
        @contact = Contact.find(contact_id)
      end
    else
      @contact = nil
    end
    return @contact
  end

  def worker
    if worker_id && !worker_id.to_s.empty?
      if( (! @worker) || (worker_id != @worker.id) )
        @worker = Worker.find(worker_id)
      end
    else
      @worker = nil
    end
    return @worker
  end

  def to_s
    return skedj_to_s("sentence")
  end

  # TODO: move the "during" part here, ( eval("@#{which_date}_date_type") == "daily" ? " on " : " during ")
  # TODO: move into skedj_to_s once they are integrated
  def date_range_to_s(thing)
    case eval("@" + thing + "_date_type")
    when 'daily'
      desc = Date.parse(eval("@" + thing + "_date").to_s).to_s
    when 'monthly'
      year = (eval("@" + thing + "_year") || Date.today.year).to_i
      start_date = Time.local(year, eval("@" + thing + "_month"), 1)
      desc = "%s, %i" % [ Date::MONTHNAMES[start_date.month], year ]
    when 'quarterly'
      year = eval("@" + thing + "_year")
      quarter = eval("@" + thing + "_quarter")
      desc = 'quarter %i of %i' % [ quarter, year ]
    when 'yearly'
      year = eval("@" + thing + "_year")
      desc = '%i' % [ year ]
    when 'arbitrary'
#      start_date = Date.parse(eval("@" + thing + "_start_date").to_s)
#      end_date = Date.parse(eval("@" + thing + "_end_date").to_s)
      stds = eval("@" + thing + "_start_date")
      stds = "Beginning of time" if stds.length == 0
      ends = eval("@" + thing + "_end_date")
      ends = "End of time" if ends.length == 0
      desc = "#{stds} to #{ends}"
    else
      desc = 'unknown date type'
    end
    return desc
  end

  def skedj_to_s(style = "before", show_date = false)
    show_date = show_date || (style == "sentence")
    mea = self.methods
    ta = mea.select{|x| x.match(/_enabled$/)}.select{|x| self.send(x.to_sym) == "true"} # TODO: look at CONDS instead
    dv = nil
    ret = ta.map{|t|
      meo = me = t.sub(/_enabled$/, "")
      v = ""
      if DATES.include?(me)
        mv = date_range_to_s(me)
        if dv.nil? and (style == "sentence")
          dv = mv
        else
          v = mv if show_date
        end
      elsif CHECKBOXES.include?(me)
        v = self.send(me) == 1
      elsif meo == 'contact' or meo == 'worker' or !mea.include?(me) or meo.match(/_id/)
        me += "_id" unless me.match(/_id/)
        meo = meo.sub(/_id/, "")
        if !mea.include?(me)
          v = ""
        else
          v = [self.send(me)].flatten.map{|it|
            obj = meo.classify.constantize.find_by_id(it)
            sendit = obj.respond_to?(:condition_to_s) ? :condition_to_s : obj.respond_to?(:description) ? :description : obj.respond_to?(:name) ? :name : :to_s
            obj ? obj.send(sendit) : nil
          }.select{|x| !x.nil?}.join(",")
        end
      else
        v = self.send(me)
      end
      res = nil
      if CHECKBOXES.include?(me)
        res = (v ? "" : " not ") + " " + meo.humanize
      elsif (v && v.respond_to?(:length) && v.length > 0)
        if style == "before"
          res = (meo.humanize + ": " + v.to_s)
        else
          res = (v.to_s + " (" + meo.humanize + ")")
        end
        if instance_variable_get("@#{meo}_excluded")
          res = "Excluding " + res
        end
      end
      res
    }.select{|x| !!x}.join(style == "sentence" ? " " : ", ")
    if style == "sentence"
      ret = "for " + ret if ret.length > 0
      if show_date
        ret += " during " + dv if dv
      end
    end
    ret
  end
end
