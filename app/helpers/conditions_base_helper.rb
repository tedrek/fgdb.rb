module ConditionsBaseHelper
  def conditions_html(params_key = "conditions", these_things = [], klass = Conditions, multiselect_mode = "auto")
    hash = {}
    klass::CONDS.select{|x| these_things.include?(x)}.each{|x|
      if klass::DATES.include?(x)
        hash[x] = date_or_date_range_picker(params_key, x)
      else
        hash[x] = eval("html_for_" + x + "_condition(params_key)")
      end
    }
    multiselect_of_form_elements(params_key, hash, multiselect_mode)
  end
end
