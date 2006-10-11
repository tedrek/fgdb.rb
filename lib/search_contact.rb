module SearchContact
  # searching for a contact

  def search(searchbox_id_arg=nil)
    set_search_vars(searchbox_id_arg=nil)
  end

  def do_search
    query_str = params[:query]
    # if the user added query wildcards, leave be
    # if not, assume it's better to bracket with wildcards
    query_str = "*#{query_str}*" unless query_str =~ /\*/
    @search_results = Contact.search( query_str )
    if @search_results.size == 0
      @contact_searchbox_search_label = "Your search for '#{query_str}' failed.<br />Search for name, city, postal code or organization:"
      set_search_vars( params[:searchbox_id] )
      render :update do |page|
        page.replace_html @contact_searchbox_id, 
          :partial => 'searchbox_field'
      end
    else
      set_search_vars( params[:searchbox_id] )
      render :update do |page|
        page.replace_html @contact_searchbox_id, :partial => 'search_dropdown'
      end
    end
  end

  def insert_searchbox
    set_search_vars( params[:searchbox_id] )
    if params[:searchbox_value] == "__search again__"
      render :update do |page|
        page.replace_html @contact_searchbox_id, 
        :partial => 'searchbox_field'
      end
    else
      @contact = Contact.find( params[:searchbox_value] )
      render :update do |page|
        page.replace_html @contact_searchbox_display_id, :partial => 'display'
      end
    end
  end

  protected

  # we usually need to create the searchbox multiple times
  def set_search_vars(contact_searchbox_id_arg=nil)
    seed = Time.now.to_i
    @contact_searchbox_id = contact_searchbox_id_arg || 
      "contact_searchbox_id_#{seed}"
    @contact_searchbox_field_id = "#{@contact_searchbox_id}_field"
    @contact_searchbox_display_id = "#{@contact_searchbox_id}_display"
    @contact_searchbox_field_name ||= "contact_id"
    @contact_searchbox_search_label ||= "Search for name, city, postal code or organization:"
    @contact_searchbox_select_label ||= "Choose a contact:"
  end
end
