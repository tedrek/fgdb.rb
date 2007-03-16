class Conditions
  def initialize
    @date = Date.today
    @date_type = 'daily'
    @month = Date.today
    @year = Date.today
  end
  attr_accessor :date, :date_type, :start_date, :end_date, :month, :year

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
    case @date_type
    when 'daily'
      date = Date.parse(@date.to_s)
      if date == Date.today
        start_date = date
        end_date = date + 1
      else
        end_date = date + 1
      end
    when 'monthly'
      year = (@year || Date.today.year).to_i
      start_date = Time.local(year, @month, 1)
      if @month.to_i == 12
        month = 1
      else
        month = 1 + @month.to_i
      end
      end_date = Time.local(year + 1, month, 1)
    when 'arbitrary'
      start_date = Date.parse(@start_date.to_s)
      end_date = Date.parse(@end_date.to_s)
    end
    return [ "#{klass.table_name}.created_at >= ? AND #{klass.table_name}.created_at < ?",
             start_date, end_date ]
  end

  def to_s
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
end
