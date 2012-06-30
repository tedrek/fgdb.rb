class ConditionsBase
  attr_accessor :mode
  attr_accessor :forced_list

  DATES = []
  CONDS = []

  def apply_conditions(options)
    @condition_applied = true
    return options unless options
    options.each do |name,val|
      if val.class == Array
        val = val.map{|x| x.to_i.to_s == x ? x.to_i : x}
      elsif val.is_a?(Hash)
        nil # no op
      else
        val = val.to_i if( val.to_i.to_s == val )
      end
      self.send(name+"=", val)
    end
    return options
  end

  def initialize
    for i in self.class::DATES
      eval("@#{i}_date = Date.today")
      eval("@#{i}_date_type = 'daily'")
      eval("@#{i}_month = Date.today")
      eval("@#{i}_year = Date.today")
      eval("@#{i}_year_only = Date.today")
      eval("@#{i}_year_q = Date.today")
    end

    init_callback
  end

  def init_callback

  end

  def _wrap_with_not(my_data, exclude_val = false)
    my_data[0] = "NOT (#{my_data[0]})" if exclude_val
    return my_data
  end

  def is_this_condition_enabled(this_condition)
    ["true", true].include?(instance_variable_get("@#{this_condition}_enabled"))
  end

  def valid?
    _validate
    @errors.length == 0
  end

  attr_writer :human_name

  def self.human_name
    @human_name || "Search conditions"
  end

  def self.human_attribute_name(f)
    f.humanize
  end

  def _validate
    if !defined?(@errors)
      @errors = ActiveRecord::Errors.new(self)
      self.validate
    end
  end

  def validate
    # in child class:    @errors.add("foo", "is bad") #if is_this_condition_enabled('foo') && @foo == 'bad'
  end

  def errors
    _validate
    @errors
  end

  def join_conditions(conds_a, conds_b, mode = "AND")
    raise ArgumentError.new("'#{conds_a}' is empty") if conds_a.empty?
    raise ArgumentError.new("'#{conds_b}' is empty") if conds_b.empty?
    return [
            (conds_a[0].empty? ? '' : '(') +
            conds_a[0].to_s +
            (conds_a[0].empty? ? '' : " #{mode} ") +
            conds_b[0].to_s +
            (conds_a[0].empty? ? '' : ')')
           ] + conds_a[1..-1] + conds_b[1..-1]
  end

  def conditions(klass)
    addthese = []
    list = @forced_list ? @forced_list.keys : []
    if !self.valid?
#      raise self.errors.full_messages.to_s # TODO: DO THIS SOMEDAY
      return ["#{klass.table_name}.id = -1"]
    end
    conds = self.class::CONDS.inject([""]) {|condition_array,this_condition|
      ret = condition_array
      if is_this_condition_enabled(this_condition)
        sql = _wrap_with_not(self.send("#{this_condition}_conditions",
                                                 klass), instance_variable_get("@#{this_condition}_excluded"))
        if list.include?(this_condition)
          addthese << sql
        else
          ret = join_conditions(condition_array, sql,  @mode || "AND")
        end
      end
      ret
    }
    puts conds.inspect
    for sql in addthese
      conds = join_conditions(conds, sql, "AND")
    end
    puts conds.inspect
    if conds[0].empty?
      conds[0]="#{klass.table_name}.id = -1"
    end
    return conds
  end
end
