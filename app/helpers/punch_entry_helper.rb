module PunchEntryHelper
  def datetime_entry(object_name, method_name, opts=nil)
    ret = ''.html_safe
    obj = instance_variable_get(('@' + object_name.to_s).to_sym)
    value = obj.send(method_name)
    ret << text_field_tag(object_name.to_s + '[' + method_name.to_s + '][date]',
                          value.nil? ? nil : value.to_date,
                          maxlength: 10,
                          size: 10,
                          class: 'date-picker')
    ret << text_field_tag(object_name.to_s + '[' + method_name.to_s + '][time]',
                          value.nil? ? nil : value.strftime('%R'),
                          maxlength: 10,
                          size: 5,
                          class: 'time-picker')
  end
end
