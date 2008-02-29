module DatalistFor
  module Helper

    def datalist_for(model, tag, collection, options = {})

      options[:tag] = tag

      #:TODO: scrub this
      klass = eval(Inflector.classify(model.to_s))

      session[tag] = {:model => klass, :options => options}

      # options
      show_header = true
      show_header = options[:show_header] unless options[:show_header].nil?
      add_text = options[:add_text] || "Add #{klass.name.capitalize}"
      exclude = options[:exclude] || []

      html = <<HTML
       <div id="datalist_#{tag}">
HTML

      html += hidden_field_tag "datalist_#{tag}_id", datalist_table_id(tag)
      html += "<table class=\"datalist\"
        id=\"#{datalist_table_id(tag)}\">"

      if show_header
        html += <<HTML
             <thead>
               <tr>
HTML

        klass.content_columns.each do |col|
          html += "<th>#{col.human_name}</th>" unless exclude.include? col.name.to_sym
        end

        html += <<HTML
                 <th>&nbsp;</th>
               </tr>
             </thead>
HTML
      end

      if collection.length == 0
        html += datalist_row(klass, tag, nil, options)
      end

      collection.each do |obj|
        html += datalist_row(klass, tag, obj, options)
      end

      html += "</td></tr></table><span class=\"datalist\">
        #{link_to_remote add_text, :url => { :action => 'datalist_add_row',
           :tag => tag,
           :datalist_id => datalist_table_id(tag)}}</span></div>"
      html
    end

    def datalist_row(model, tag, obj = nil, options = {})

      exclude = options[:exclude] || []

      if obj.nil?
        item_mode = 'datalist_new'
        item_id = ( Time.now.to_f * 1000 ).to_i
      else
        item_mode = 'datalist_update'
        item_id = obj.id
      end

      item_identifier =
        "#{item_mode}_#{tag}_#{item_id}"

      delete_content = options[:delete_content] || 'Delete'

      html = "<tr id=\"remove_me_#{item_identifier}\" class=\"datalist #{cycle('even', 'odd')}\">"

      if options.has_key? :render or options.has_key? :render_aware
        unless obj
          obj = model.new
          # some new item default values are context sensitive
          # here is one means of letting controller set them
          # in coordination only with new_edit partial for now
          if( options.has_key?(:new_defaults) && options[:new_defaults].respond_to?(:has_key?) )
            if options[:new_defaults].has_key? tag.to_sym
              options[:new_defaults][tag.to_sym].each do |col,v|
                col_setter = (col.to_s + '=').to_sym
                obj.send(col_setter, v) if obj.respond_to? col_setter
              end
            end
          end
        end
        form_prefix = Inflector.underscore(model.name)
        if options.has_key? :render_aware
          form = render :partial => options[:render_aware],
          :locals => {
            "@#{form_prefix}" => obj,
            "@datalist_field_name_prefix" => "#{item_mode}[#{tag}][#{item_id}]",
            "@datalist_field_id_prefix" => "#{item_mode}_#{tag}_#{item_id}"
          }
          html += form
        else
          form = render( :partial => options[:render],
                         :locals => {
                           "@#{form_prefix}" => obj
                         } )
          html += alter_fields_for_datalist(form, form_prefix, item_mode, tag, item_id)
        end
      else
        model.content_columns.each do |col|
          unless exclude.include? col.name.to_sym
            field_name = "#{item_mode}[#{tag}][#{item_id}][#{col.name}]"
            existing_value = obj.attributes[col.name] if obj
            html += "<td>"
            html += case col.type
                    when :boolean then check_box_tag field_name, 1, existing_value
                    when :text then text_area_tag field_name, existing_value, :rows => 3, :cols => 30
                    else text_field_tag field_name, existing_value
                    end
            html += "</td>"
          end
        end
      end

      html += "<td>
          <span id=\"delete_#{item_identifier}\">"

      html += link_to_remote delete_content, :url => { :action => 'datalist_delete_row', :tag => tag, :id => item_identifier }

      html += "</span>
        </td>
      </tr>"

    end

    def datalist_text_field(object_name, field_name, options = {})
      %Q?<input type="text" %s
        name="%s"
        id="%s"
        value="%s" /> ? % [
          options.map {|opt,val| %Q?#{opt}="#{val}"? }.join(" "),
          "#{@datalist_field_name_prefix}[#{field_name}]",
          "#{@datalist_field_id_prefix}_#{field_name}",
          instance_variable_get("@#{object_name}").send( field_name )
        ]
    end

    def datalist_check_box(object_name, field_name, options = {})
      %Q?<input type="checkbox" %s
        name="%s"
        id="%s" value="1"
        %s >? % [
          options.map {|opt,val| %Q?#{opt}="#{val}"? }.join(" "),
          "#{@datalist_field_name_prefix}[#{field_name}]",
          "#{@datalist_field_id_prefix}_#{field_name}",
          instance_variable_get("@#{object_name}").send( field_name ) ? "CHECKED" : ""
        ]
    end

    def datalist_table_id(tag)
      "datalist-#{tag}-table"
    end

    def alter_fields_for_datalist(form, form_prefix, item_mode, tag, item_id)
      form.gsub( /(name=")#{form_prefix}\[(\w*)\]/ ) {|match|
        "#$1#{item_mode}[#{tag}][#{item_id}][#$2]"
      }.gsub( /(id=")#{form_prefix}_(\w*)/ ) {|match|
        "#$1#{item_mode}_#{tag}_#{item_id}_#$2"
      }
    end

  end
end
