module ContactsHelper
  def loading_indicator_id(options)
    'loading_indicator_id'
  end

  def loading_indicator_tag(options)
    "<div id=\"#{loading_indicator_id(options)}\" />"
  end

  def searchbox_select_name(options)
    options[:select_name] || 'contact_id'
  end

  def searchbox_select_id(options)
    'searchbox_select_id'
  end

  def searchbox_select_label(options)
    'searchbox_select_label'
  end

  def element_form_id(options)
    'element_form_id'
  end

  def contact_messages_id(options)
    'contact_messages_id'
  end
end
