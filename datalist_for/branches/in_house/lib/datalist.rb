#!/usr/bin/env ruby
# in your controller:
# -------------------
#   def new
#     # ...
#     @items = Datalist.new('tagname', MyItem, :datalist_aware_form => true,
#       :init_defaults => {})
#     @items.form = 'controller/line_item'
#     @items.onchange {|page|
#       page.insert_html :bottom, 'tally', :partial => 'tally_item'
#     }
#   end
#   def update
#     # ...
#     @items = Datalist.load('tagname', params)
#     @my_thing.list_items = @items.objects(:extra_attr => 'no worries')
#     @successful = @my_thing.save
#   end
# in your _form.html:
# -------------
#    <%= @items.render %>

class Datalist

  def Datalist.load(tag, params)
    klass = eval(params[tag][:model])
    list = Datalist.new(tag, klass)
    list.extricate_options( params )
    list.extricate_objects( params )
    list
  end

  DEFAULTS = {
    :exclude => []
  }

  def initialize(tag, klass, options = {})
    @tag = tag
    @klass = klass
    @options = DEFAULTS.merge(options)
  end

  attr_accessor :form

  def objects
    @objects
  end

  def onchange(&block)
    @onchange_callback = block
  end

  def render(locals = {})
    js = ''
    if @onchange_callback
      js = update_page( &@onchange_callback )
    end
    if @form
      if @options[:datalist_aware_form]
        render_aware_form(locals, js)
      else
        render_provided_form(locals, js)
      end
    else
      render_generic_form(locals, js)
    end
  end

  def extricate_objects(params)
    @objects = []
    params[@tag][:created].each {|data|
      obj = @klass.new
      obj.attributes = data
      @objects << obj
    }
    params[@tag][:updated].each {|data|
      obj = @klass.find(data[:id])
      obj.attributes = data
      @objects << obj
    }
  end

  def extricate_options(params)
  end

  #########
  protected
  #########

  def render_aware_form(locals, js)
    ''
  end

  def render_provided_form(locals, js)
    ''
  end

  def render_generic_form(locals, js)
    html = '<table>'
    html += generic_row
    html += '</table>'
    html
  end

  def generic_row(obj = nil)
    if obj.nil?
      item_mode = 'datalist_new'
      item_id = ( Time.now.to_f * 1000 ).to_i
    else
      item_mode = 'datalist_update'
      item_id = obj.id
    end
      
    item_identifier =
      "#{item_mode}_#{@tag}_#{item_id}"
        
    delete_content = @options[:delete_content] || 'Delete'
        
    html = "<tr id=\"remove_me_#{item_identifier}\" class=\"datalist\">"
      
    @klass.content_columns.each do |col|
      unless @options[:exclude].include? col.name.to_sym
        field_name = "#{item_mode}[#{@tag}][#{item_id}][#{col.name}]"
        existing_value = obj.attributes[col.name] if obj
        html += "<td>"
        html += case col.type
                when :boolean then check_box_tag field_name, 1, existing_value
                when :text then text_area_tag field_name, existing_value, :rows => 3, :cols => 30
                else text_field_tag field_name, existing_value
                end
        html += "</td>"
      end
      
      html += "<td>
          <span id=\"delete_#{item_identifier}\">"

      html += link_to_remote delete_content, :url => { :action => 'datalist_delete_row', :model => @klass, :id => item_identifier }
      
      html += "</span>
          </td>
        </tr>"
    end

    return html
  end

  def other_stuff
    if @options.has_key? :render or @options.has_key? :render_aware
        unless obj
          obj = @klass.new
          # some new item default values are context sensitive
          # here is one means of letting controller set them
          # in coordination only with new_edit partial for now
          if @options.has_key? :new_defaults
            if @options[:new_defaults].has_key? @tag.to_sym
              @options[:new_defaults][@tag.to_sym].each do |col,v|
                col_setter = (col.to_s + '=').to_sym
                obj.send(col_setter, v) if obj.respond_to? col_setter
              end
            end
          end
        end
        form_prefix = Inflector.underscore(@klass.name)
        if @options.has_key? :render_aware
          form = render :partial => @options[:render_aware],
          :locals => {
            "@#{form_prefix}" => obj,
            "@datalist_field_name_prefix" => "#{item_mode}[#{@tag}][#{item_id}]",
            "@datalist_field_id_prefix" => "#{item_mode}_#{@tag}_#{item_id}"
          }
          html += form #alter_fields_for_datalist(form, form_prefix, item_mode, @tag, item_id)
        else
          form = render :partial => @options[:render],
          :locals => {
            "@#{form_prefix}" => obj
          }
          html += alter_fields_for_datalist(form, form_prefix, item_mode, @tag, item_id)
        end
      else
    end
  end


end # class Datalist
