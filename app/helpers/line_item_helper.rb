module LineItemHelper
  protected

  def line_item_includes
    javascript_include_tag("new_line_items")
  end

  # TODO: this should probably have a class API rather than passing
  # prefix everywhere...

  def line_item_instance_js(prefix, klass)
    javascript_tag("#{line_item_instance_name_for(prefix)} = new #{klass};")
  end

  def line_item(prefix, klass, form_oh, values = [])
    line_item_instance_js(prefix, klass) + line_item_form_for(prefix, form_oh).to_s + ((values.length > 0) ? line_item_add_many(prefix, values) : "")
  end

  include TableHelper

  def line_item_form_for(prefix, form_oh)
    a = [(form_oh.keys.map{|x| x.to_s.titleize} + [""]), ([{:id => (prefix) + "_form"}] + form_oh.values.map{|x| x.to_s} + [""])]
    make_table(a, {:id => (prefix) + "_lines", :border => "0"})
  end

  def line_item_instance_name_for(prefix)
    "#{prefix}_instance"
  end

  # onkeydown="#{line_item_on_keydown(prefix)}"
  def line_item_on_keydown(prefix)
    "return #{line_item_instance_name_for(prefix)}.handle_event(event);"
  end

  def line_item_add_many(prefix, to_add)
    javascript_tag "#{line_item_instance_name_for(prefix)}.add_many(#{to_add.to_json});"
  end

  def apply_line_item_data(object, thing_klass, prefix = nil)
    prefix = thing_klass.table_name if prefix.nil?
    prefix = prefix.to_sym
    input = params[prefix]
    arr = []
    if input
      for i in input.values
        t = thing_klass.new_or_edit(i)
        arr << t
      end
    end
    orig = object.send(prefix).map{|x| x}
    object.send((prefix.to_s + "=").to_sym, arr)
    fkey_name = object.class.table_name.singularize + "_id"
    orig.map{|x| thing_klass.find(x.id)}.each{|x| x.destroy if x.send(fkey_name.to_sym).nil?}
    arr
  end
end
