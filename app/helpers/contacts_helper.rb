module ContactsHelper
  def searchbox_select_name(options)
    options[:select_name] || 'contact_id'
  end

  def searchbox_select_id(options)
    options[:select_id] || contact_element_prefix(options) + '_searchbox_select_id'
  end

  def searchbox_select_label(options)
    'searchbox_select_label'
  end

  def element_form_id(options)
    'element_form_id'
  end

  def contact_messages_id(options)
    contact_element_prefix(options) + '_contact_messages_id'
  end
end
