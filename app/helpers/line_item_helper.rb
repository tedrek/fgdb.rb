module LineItemHelper
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

  def line_item_on_change(prefix)
    # TODO, handles the event and the list of elements. this was never
    # used on contact methods but is used elsewhere.
  end

  def line_item_add_many(prefix, to_add)
    javascript_tag "#{line_item_instance_name_for(prefix)}.add_many(#{to_add.to_json});"
  end
end
