class Skedjul
  def initialize(hash, params)
    if hash[:views]
      myview = ((params["opts"] ? params["opts"]["current_view"] : nil) || hash[:default_view])
      myview = myview.to_sym
      hash[:current_view] = myview
      hash["current_view"] = myview

      for k in hash[:views][myview].keys
        hash[k] = hash[:views][myview][k]
      end
    end

    @__opts = hash

    opts[:presentation_mode] = (params[:opts].nil? ? nil : params[:opts]['presentation_mode']) || 'Edit'
    opts["presentation_mode"] = opts[:presentation_mode] # FIXME

    return unless opts[:conditions]

    default_conds = {}
    thing = nil
    if opts[:date_range_condition]
      c = opts[:date_range_condition]
      default_conds[(c+"_enabled").to_s] = "true"
      default_conds[(c+"_date_type").to_s] = "arbitrary"
      default_conds[(c+"_start_date").to_s] = Date.today.to_s
      default_conds[(c+"_end_date").to_s] = (Date.today + 14).to_s
      default_conds["empty_enabled"] = "true"
      thing = (c+"_date_type").to_s
    end
    if opts[:forced_condition]
      c = opts[:forced_condition]
      default_conds[(c+"_enabled").to_s] = "true"
    end

    @__conditions = Conditions.new
    params[:conditions] ||= default_conds
    if !thing.nil?
      params[:conditions][thing] = "arbitrary"
    end
    default_conds.to_a.each{|k,v|
      if !params[:conditions].keys.include?(k)
        params[:conditions][k] = v
      end
    }
    params[:conditions]["empty_enabled"] = "true"
    @__conditions.apply_conditions(params[:conditions])
  end

  def where_clause
    DB.prepare_sql(@__conditions.conditions(klass))
  end

  def conditions
    @__conditions
  end

  def set_current(thing)
    @last = @current
    @current = thing
  end

  def current
    @current
  end

  def last
    @last
  end

  def klass
    @__klass ||= eval(opts[:thing_table_name].classify)
  end

  def opts
    @__opts
  end

  def order_by
    # 'work_shifts.shift_date, workers.name, work_shifts.start_time'
    str = "#{opts[:block_method_name]}, #{opts[:left_sort_value] || opts[:left_method_name]}, #{opts[:thing_start_time]}"
    list = str.split(",")
    fin = []
    list.each{|x|
      if x.match(/^\s*[\(]/)
        fin << x
        next
      end
      a = x.split(".")
      s = a[-1]
      if a[-2]
        s = a[-2] + "." + s
      end
      fin << s
    }
    fin.join(", ")
  end

  def find(opts = {})
    @__results = klass.find(:all, {:conditions => self.where_clause, :order => self.order_by}.merge(opts))
  end

  def find_by_sql(sql)
    @__results = klass.find_by_sql(sql)
  end

  def results
    @__results
  end

  def new_number
    @number_i ||= 0
    @number_i += 1
    @number_i
  end

  def get_method_value(thing, str, foo = nil)
    if thing.nil?
      return
    end
    if foo.nil?
      foo = opts[str]
    end
    if foo.match(/,/)
      return foo.split(/, */).map{|x| get_method_value(thing, nil, x)}.join(" ")
    end
#    puts "looking at #{foo}"
    a = foo.split(/\./)
    t = thing
    if a.length > 1
      if a.first == opts[:thing_table_name]
        a.shift
        return get_method_value(t, nil, a.join("."))
      end
      while a.length > 1
        t = t.send(a.shift.singularize.to_sym)
        if t.nil?
          return nil
        end
      end
      return t.send(a.last.to_sym)
    else
      return t.send(a.first.to_sym)
    end
  end

  def get_table_value(thing, str)
    get_method_value(thing, nil, opts[str] + ".self")
  end
end

module SkedjulHelper
  def skedjul_widget(hash)
    Skedjul.new(hash)
  end

  def skedjul_links(skedj)
    current = skedj.current
    links = skedj.opts[:thing_links] #
    tid = skedj.get_method_value(current, :thing_link_id)
    if skedj.opts.keys.include?(:thing_link_controller)
      skedj.opts[:thing_link_controller]
    elsif current.respond_to?(:skedjul_link_controller)
      controller = current.send(:skedjul_link_controller)
    else
      controller = skedj.opts[:thing_table_name]
    end

    this_id = skedj.new_number

    a = []
    links.each{|mya|
      action = mya[0]
      type = mya[1]
      cond = mya[2]
      letter = mya[3]
      letter ||= action.to_s.scan(/./).first
      html_opts = {:title => action}
      url_opts = { :controller => controller, :action => action, :id => tid }
      func = :link_to
      if type == :popup
        html_opts[:popup] = true
      elsif type == :confirm
        html_opts[:confirm] = 'Are you sure?'
      elsif type == :function
        func = :link_to_function
        url_opts = url_opts[:action].to_s + "(#{tid});"
      elsif type == :remote
        func = :link_to_remote
        url_opts[:url] = url_opts.dup # yuck
        url_opts[:url][:skedjul_loading_indicator_id] = this_id
        url_opts[:loading] = "Element.show('#{loading_indicator_id("skedjul_#{this_id}_loading")}');"
      end
      if cond.nil? or current.send(cond)
        a << self.send(func, letter, url_opts, html_opts)
      end
    }
    return loading_indicator_tag("skedjul_#{this_id}_loading") + a.join(" | ")
  end
end
