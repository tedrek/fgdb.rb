class Conditions
  def initialize
    @limit_type = 'date range'
    @date = Date.today
    @date_type = 'daily'
    @month = Date.today
    @year = Date.today
    @payment_method_id = PaymentMethod.cash.id
  end
  # primary selection
  attr_accessor :limit_type
  # date range selections
  attr_accessor :date, :date_type, :start_date, :end_date, :month, :year
  # contact attrs
  attr_accessor :contact_id
  # payment method attrs
  attr_accessor :payment_method_id

  def contact
    if contact_id
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
  end

  def conditions(klass)
    case @limit_type
    when 'date range'
      date_range_conditions(klass)
    when 'contact'
      contact_conditions(klass)
    when 'payment method'
      payment_method_conditions(klass)
    end
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
    case klass
    when Disbursement
      column_name = 'disbursed_at'
    when Recycling
      column_name = 'recycled_at'
    else
      column_name = 'created_at'
    end  
    $stderr.puts("#{klass} #{column_name}\n")
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

  def to_s
    case @limit_type
    when 'date range'
      date_range_to_s
    when 'contact'
      contact_to_s
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
      desc = "from #{start_date} to #{end_date}"
    else
      desc = 'unknown date type'
    end
    return desc
  end

  def contact_to_s
    return "belonging to %s" % contact.display_name
  end
end
