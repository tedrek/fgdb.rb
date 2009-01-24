module ConditionsHelper
  def only_these(hash, keys)
    keys = keys.map{|x| x.to_s}
    Hash[hash.select{|k,v| keys.include?(k)}]
  end

  def conditions_html(params_key = "conditions", these_things = nil)
    hash = {}
    Conditions.conds.each{|x|
      if Conditions.dates.include?(x)
        hash[x] = date_or_date_range_picker(params_key, x)
      else
        hash[x] = eval("html_for_" + x + "_condition(params_key)")
      end
    }
    if these_things
      hash = only_these(hash, these_things)
    end
    multiselect_of_form_elements(params_key, hash)
  end

  def html_for_id_condition(params_key)

  end

  def html_for_contact_type_condition(params_key)

  end

  def html_for_needs_attention_condition(params_key)

  end

  def html_for_anonymous_condition(params_key)

  end

  def html_for_unresolved_invoices_condition(params_key)

  end

  def html_for_payment_method_condition(params_key)

  end

  def html_for_payment_amount_condition(params_key)

  end

  def html_for_gizmo_type_id_condition(params_key)

  end

  def html_for_covered_condition(params_key)

  end

  def html_for_postal_code_condition(params_key)

  end

  def html_for_city_condition(params_key)

  end

  def html_for_phone_number_condition(params_key)

  end

  def html_for_contact_condition(params_key)

  end

  def html_for_volunteer_hours_condition(params_key)

  end

  def html_for_email_condition(params_key)

  end

  def html_for_flagged_condition(params_key)

  end

  def html_for_system_condition(params_key)

  end

  def html_for_contract_condition(params_key)

  end

  def html_for_created_by_condition(params_key)

  end

  def html_for_cashier_created_by_condition(params_key)

  end
end
