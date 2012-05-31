module ConditionsBaseHelper
  def conditions_html(params_key = "conditions", these_things = [], klass = Conditions, multiselect_mode = "auto", date_range = nil)
    @conditions_internal_date_range = date_range
    hash = {}
    obj = eval("@#{params_key}") || klass.new
    these_things.sort.each{|x|
      if klass::DATES.include?(x)
        hash[x] = date_or_date_range_picker(params_key, x)
      elsif klass::CONDS.include?(x)
        hash[x] = ""
        hash[x] = eval("html_for_" + x + "_condition(params_key)")
      else
        raise "Unknown condition: #{x}"
      end
      hash[x] = "<div style=\"display: inline-block;\">" + label_tag("#{params_key}[#{x}_excluded]", "Exclude?") + check_box_tag("#{params_key}[#{x}_excluded]", "#{x}_excluded", obj.send("#{x}_excluded")) + "</div>" + hash[x] unless Conditions::CHECKBOXES.include?(x) or x == "empty" or multiselect_mode == "force"
    }
    multiselect_of_form_elements(params_key, hash, multiselect_mode)
  end
end
