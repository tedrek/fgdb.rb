class Conditions
  def initialize
    @date_range_enabled = "true"
    @date = Date.today
    @date_type = 'daily'
    @month = Date.today
    @year = Date.today
    @payment_method_id = PaymentMethod.cash.id
  end

  attr_accessor :date, :date_type, :start_date, :end_date, :month, :year

  attr_accessor :contact_id

  attr_accessor :payment_method_id

  attr_accessor :id

  attr_accessor :needs_attention

  attr_accessor :anonymous

  attr_accessor :unresolved_invoices

  attr_accessor :gizmo_type_id_enabled, :gizmo_type_id

  attr_accessor :payment_amount_type, :payment_amount_exact, :payment_amount_low, :payment_amount_high, :payment_amount_ge, :payment_amount_le

  attr_accessor :contact_type

  attr_accessor :city, :postal_code, :phone_number

  attr_accessor :volunteer_hours_type, :volunteer_hours_exact, :volunteer_hours_low, :volunteer_hours_high, :volunteer_hours_ge, :volunteer_hours_le

  attr_accessor :date_range_enabled, :needs_attention_enabled, :unresolved_invoices_enabled, :contact_enabled, :payment_method_enabled, :id_enabled, :anonymous_enabled, :payment_amount_enabled, :contact_type_enabled, :city_enabled, :postal_code_enabled, :phone_number_enabled, :volunteer_hours_enabled

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

  def apply_conditions(options)
    begin
      options.each do |name,val|
        val = val.to_i if( val.to_i.to_s == val )
        self.send(name+"=", val)
      end
    rescue NoMethodError
      nil
    end
    return options
  end

  def conditions(klass)
    conds = %w[
      id contact_type needs_attention anonymous
      unresolved_invoices date_range payment_method
      payment_amount gizmo_type_id postal_code
      city phone_number contact volunteer_hours
    ].inject([""]) {|condition_array,this_condition|
      if instance_variable_get("@#{this_condition}_enabled") == "true"
        join_conditions(condition_array,
                        self.send("#{this_condition}_conditions",
                                  klass))
      else
        condition_array
      end
    }
    if conds[0].empty?
      conds[0]="#{klass.table_name}.id = -1"
    end
    return conds
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

  def id_conditions(klass)
    return ["#{klass.table_name}.id = ?", @id]
  end

  def postal_code_conditions(klass)
    return ["#{klass.table_name}.postal_code ILIKE '?%'", @postal_code]
  end

  def city_conditions(klass)
    return ["#{klass.table_name}.city ILIKE ?", @city]
  end

  def phone_number_conditions(klass)
    phone_number = @phone_number.to_s.gsub(/[^[:digit:]]/, "")
    if phone_number.length != 10
      return [""]
    end
    phone_number = phone_number.sub(/^(.{3})(.{3})(.{4})$/, "%\\1%\\2%\\3%")
    return ["#{klass.table_name}.id IN (SELECT contact_id FROM contact_methods WHERE contact_method_type_id IN (SELECT id FROM contact_method_types WHERE (description ILIKE '%phone%') OR (description ILIKE '%fax%')) AND description ILIKE ?)", phone_number]
  end

  def contact_type_conditions(klass)
    return ["#{klass.table_name}.id IN (SELECT contact_id FROM contact_types_contacts WHERE contact_type_id = ?)", @contact_type]
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

  def date_range_conditions(klass)
    case @date_type
    when 'daily'
      start_date = Date.parse(@date.to_s)
      end_date = start_date + 1
    when 'monthly'
      year = (@year || Date.today.year).to_i
      start_date = Time.local(year, @month, 1)
      if @month.to_i == 12
        end_month = 1
        end_year = year + 1
      else
        end_month = 1 + @month.to_i
        end_year = year
      end
      end_date = Time.local(end_year, end_month, 1)
    when 'arbitrary'
      start_date = Date.parse(@start_date.to_s)
      end_date = Date.parse(@end_date.to_s) + 1
    end
    case klass.to_s
    when 'Disbursement'
      column_name = 'disbursed_at'
    when 'Recycling'
      column_name = 'recycled_at'
    when 'GizmoEvent'
      column_name = 'occurred_at'
    else
      column_name = 'created_at'
    end
    return [ "#{klass.table_name}.#{column_name} >= ? AND #{klass.table_name}.#{column_name} < ?",
             start_date, end_date ]
  end

  def contact_conditions(klass)
    return [ "#{klass.table_name}.contact_id = ?", contact_id ]
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

  def to_s
    if @date_range_enabled=="true" && @contact_enabled=="true"
      " by " + contact_to_s(show_contact_name) + ( @date_type == "daily" ? " on " : " during ") + date_range_to_s
    elsif(@date_range_enabled=="true")
      ( @date_type == "daily" ? " on " : " during ") + date_range_to_s
    elsif(@contact_enabled=="true")
      " by " + contact_to_s
    else
      ""
    end
  end

  def date_range_to_s
    case @date_type
    when 'daily'
      desc = Date.parse(@date.to_s).to_s
    when 'monthly'
      year = (@year || Date.today.year).to_i
      start_date = Time.local(year, @month, 1)
      desc = "%s, %i" % [ Date::MONTHNAMES[start_date.month], year ]
    when 'arbitrary'
      start_date = Date.parse(@start_date.to_s)
      end_date = Date.parse(@end_date.to_s)
      desc = "#{start_date} to #{end_date}"
    else
      desc = 'unknown date type'
    end
    return desc
  end

  def contact_to_s # "Report of hours worked for ..."
    return contact.display_name
  end
end
