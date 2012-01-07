class ConditionsBase
  DATES = []
  CONDS = []

  def apply_conditions(options)
    options.each do |name,val|
      if val.class != Array
        val = val.to_i if( val.to_i.to_s == val )
      else
        val = val.map{|x| x.to_i.to_s == x ? x.to_i : x}
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

  def conditions(klass)
    if !self.valid?
      return ["#{klass.table_name}.id = -1"]
    end
    conds = self.class::CONDS.inject([""]) {|condition_array,this_condition|
      if is_this_condition_enabled(this_condition)
        join_conditions(condition_array,
                        _wrap_with_not(self.send("#{this_condition}_conditions",
                                                 klass), instance_variable_get("@#{this_condition}_excluded")))
      else
        condition_array
      end
    }
    if conds[0].empty?
      conds[0]="#{klass.table_name}.id = -1"
    end
    return conds
  end
end
