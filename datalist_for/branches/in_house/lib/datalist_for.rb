module DatalistFor

  def datalist_add_row
    klass = eval(params[:model])
    options = Marshal.load(Base64.decode64(params[:options]))
    render :update do |page|
      page.insert_html :bottom, params[:datalist_id], datalist_row(klass, options[:tag], nil, options)
      # :MC: how/when would i focus on this new row?
    end
  end

  def datalist_delete_row
    eval(params[:model]).delete(params[:id].split('_').last) if params[:id]['datalist_update']

    render :update do |page|
      div_id = "remove_me_#{params[:id]}"
      #:MC: this cas giving us infinite recusion in js...
#      page.visual_effect :fade, div_id, :duration => 0.5
      #page.delay(0.5) {
      page.remove div_id # }
    end
  end

  def save_datalist(tag, create_with_new = nil)
    model = eval(params["datalist_#{tag}_model".to_sym])
    existing_okay = save_existing(tag, model) if params[:datalist_update]
    new_okay = save_new(tag, model, create_with_new) if params[:datalist_new]
    (existing_okay or ! params[:datalist_update]) && (new_okay or ! params[:datalist_new])
  end

  # The params data for all displayed datalist rows.
  def datalist_data(tag)
    data = existing_datalist_data_to_keep(tag)
    new_datalist_data_to_keep(tag).each do |key,val|
      data["new_#{key.to_s}"] = val
    end
    data
  end

  def datalist_objects(tag, create_with_new = nil)
    return [] unless params.has_key?("datalist_#{tag}_model".to_sym)
    model = eval(params["datalist_#{tag}_model".to_sym])
    objs = []
    if params[:datalist_update]
      objs += existing_datalist_objects_to_keep(tag, model)
    end
    if params[:datalist_new]
      objs += new_datalist_objects(tag, model, create_with_new)
    end
    return objs
  rescue Exception => e
    $stderr.puts(e.to_s, e.backtrace)   
  end

  def apply_datalist_to_collection(tag, collection, create_with_new = nil)
    bad_recs = []
    # update
    keepers = existing_datalist_data_to_keep(tag)
    collection.each_with_index {|obj, i|
      if keepers[obj.id]
        # the collection may or may not already have all these, so remember which
        obj.attributes = keepers.delete(obj.id)
      else
        # the collection may have too many things, so remember them as well
        bad_recs << obj
      end
    }
    keepers.each {|oid,data|
      collection.build(data.merge( {:id => oid} ))
    }
    # delete
    collection.delete(*bad_recs)
    # create
    new_datalist_data_to_keep(tag).each {|fakeid,data|
      collection.build(data)
    }
  end


  #########
  protected
  #########

  def save_existing(tag, model)
    # there should only be one datalist of a particular tag per
    # form, thus we ignore the index and choose the first
    existing_data = existing_datalist_data(tag)
    existing_objects = existing_datalist_objects(tag, model)
    successful_objects = existing_objects.find_all do |obj|
      if keeper?(existing_data, obj.id)
        if obj.valid?
          obj.save
          true
        elsif obj.respond_to?(:mostly_empty?) and obj.mostly_empty?
          true
        else
          flash[:error] = "Fill in #{Inflector.humanize(tag)} fields correctly."
          false
        end
      else
        obj.destroy
        true
      end
    end
    existing_objects.empty? or (successful_objects.length == existing_objects.length)
  end

  def save_new(tag, model, create_with_new)
    new_data = new_datalist_data(tag)
    create_with = create_with_new || Marshal.load(Base64.decode64(params["datalist_#{tag}_options".to_sym]))[:create_with]
    successful_actions = new_data.find_all do |fake_id, vals|
      if keeper?(new_data, fake_id)
        obj = create_new_obj(vals, model, create_with)
        if obj.valid?
          obj.save
        elsif obj.respond_to?(:mostly_empty?) and obj.mostly_empty?
          true
        else
          flash[:error] = "Fill in #{Inflector.humanize(tag)} fields correctly."
          false
        end
      else
        true
      end
    end
    new_data.empty? or (successful_actions.length == new_data.length)
  end

  def create_new_obj(data, model, create_with)
    obj = model.new(create_with)
    data.each do |col,val|
      obj.send(col+'=', val)
    end
    obj
  end

  def new_datalist_objects(tag, model, create_with_new)
    new_data = new_datalist_data(tag)
    new_data.keys.map do |id|
      obj = model.new(create_with_new)
      new_data[id].each do |col,val|
        obj.send(col+'=', val)
      end
      obj
    end
  end

  def existing_datalist_objects(tag, model)
    existing = existing_datalist_data(tag)
    model.find(existing.keys).map do |obj|
      existing[obj.id.to_s].each do |col,val|
        obj.send(col+'=', val)
      end
      obj
    end
  end

  def existing_datalist_objects_to_keep(tag, model)
    existing = existing_datalist_data_to_keep(tag)
    model.find(existing.keys).map do |obj|
      existing[obj.id.to_s].each do |col,val|
        obj.send(col+'=', val)
      end
      obj
    end
  end

  def new_datalist_data_to_keep(tag)
    new_data = new_datalist_data(tag)
    data = {}
    new_data.each {|key,vals|
      data[key] = vals if keeper?(new_data, key)
    }
    data
  end

  def new_datalist_data(tag)
    if params[:datalist_new] and params[:datalist_new][tag.to_sym]
      params[:datalist_new][tag.to_sym]
    else
      {}
    end
  end

  def existing_datalist_data(tag)
    if params.has_key?(:datalist_update) and params[:datalist_update].has_key?(tag.to_sym)
      params[:datalist_update][tag.to_sym]
    else
      {}
    end
  end

  def existing_datalist_data_to_keep(tag)
    existing = existing_datalist_data(tag)
    data = {}
    existing.each {|key,vals|
      data[key] = vals if keeper?(existing, key)
    }
    data
  end

  def existing_datalist_data_to_destroy(tag)
    existing = existing_datalist_data(tag)
    data = {}
    existing.each {|key,vals|
      data[key] = vals unless keeper?(existing, key)
    }
    data
  end

  # check hash for fields for this id and verify them to be
  # non-empty
  def keeper?(hash, id)
    hash[id.to_s].detect {|fieldname,fieldval|
      fieldval != ''
    }
  end

end
