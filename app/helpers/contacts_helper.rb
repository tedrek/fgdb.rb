module ContactsHelper
  def loading_indicator_id(params)
    'loading_indicator_id'
  end

  def loading_indicator_tag(params)
    "<div id=\"#{loading_indicator_id(params)}\" />"
  end

  def searchbox_display_id(params)
    'searchbox_display_id'
  end

  def searchbox_select_name(params)
    'contact_id'
  end

  def searchbox_select_id(params)
    'searchbox_select_id'
  end

  def searchbox_select_label(params)
    'searchbox_select_label'
  end

  def element_form_id(params)
    'element_form_id'
  end

  def contact_messages_id(options)
    'contact_messages_id'
  end
end
