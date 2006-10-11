class ContactsController < ApplicationController
  include AjaxScaffold::Controller
  include ContactsHelper
  
  after_filter :clear_flashes
  before_filter :update_params_filter
  
  def update_params_filter
    update_params :default_scaffold_id => "contact", :default_sort => nil, :default_sort_direction => "asc"
  end
  def index
    redirect_to :action => 'list'
  end
  def return_to_main
    # If you have multiple scaffolds on the same view then you will want to change this to
    # to whatever controller/action shows all the views 
    # (ex: redirect_to :controller => 'AdminConsole', :action => 'index')
    redirect_to :action => 'list'
  end

  def list
  end
  
  # All posts to change scaffold level variables like sort values or page changes go through this action
  def component_update
    @show_wrapper = false # don't show the outer wrapper elements if we are just updating an existing scaffold 
    if request.xhr?
      # If this is an AJAX request then we just want to delegate to the component to rerender itself
      component
    else
      # If this is from a client without javascript we want to update the session parameters and then delegate
      # back to whatever page is displaying the scaffold, which will then rerender all scaffolds with these update parameters
      return_to_main
    end
  end

  def component  
    @show_wrapper = true if @show_wrapper.nil?
    @sort_sql = Contact.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{Contact.table_name}.#{Contact.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @contacts = paginate(:contacts, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @contact = Contact.new
    @successful = true

    return render(:action => 'new.rjs') if request.xhr?

    # Javascript disabled fallback
    if @successful
      @options = { :action => "create" }
      render :partial => "new_edit", :layout => true
    else 
      return_to_main
    end
  end
  
  def create
    begin
      @contact = Contact.new(params[:contact])
      @successful = @contact.save
      @contact.contact_types = ContactType.find(@params[:contact_types]) if @params[:contact_types]
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'create.rjs') if request.xhr?
    if @successful
      return_to_main
    else
      @options = { :scaffold_id => params[:scaffold_id], :action => "create" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def edit
    begin
      @contact = Contact.find(params[:id])
      @successful = !@contact.nil?
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'edit.rjs') if request.xhr?

    if @successful
      @options = { :scaffold_id => params[:scaffold_id], :action => "update", :id => params[:id] }
      render :partial => 'new_edit', :layout => true
    else
      return_to_main
    end    
  end

  def update
    begin
      @contact = Contact.find(params[:id])
      @contact.contact_types = ContactType.find(@params[:contact_types]) if @params[:contact_types]
      @successful = @contact.update_attributes(params[:contact])
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'update.rjs') if request.xhr?

    if @successful
      return_to_main
    else
      @options = { :action => "update" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def destroy
    begin
      @successful = Contact.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'destroy.rjs') if request.xhr?
    
    # Javascript disabled fallback
    return_to_main
  end
  
  def cancel
    @successful = true
    
    return render(:action => 'cancel.rjs') if request.xhr?
    
    return_to_main
  end

  # searching for a contact

  def search
    @search_vars = init_contact_search_vars
  end

  def do_search
    query_str = params[:query]
    # if the user added query wildcards, leave be
    # if not, assume it's better to bracket with wildcards
    unless query_str =~ /\*/
      query_str = query_str.split.map do |word|
        "*#{word}*" 
      end.join(' ')
    end
    @search_results = Contact.search( query_str, :limit => default_per_page )
    @search_vars = get_contact_search_vars( params[:searchbox_id] )
    if @search_results.size == 0
      @search_vars[:notices] = "Your search for '#{query_str}' failed."
      partial = 'searchbox_field'
    elsif @search_results.size >= default_per_page
      @search_vars[:notices] = "Your search for '#{query_str}'
        returned too many results to disply.  You may want to
        refine your search."
      partial = 'search_dropdown'
    else
      partial = 'search_dropdown'
    end
    render :update do |page|
      page.replace_html @search_vars[:id], :partial => partial
    end
  end

  def update_searchbox
    @search_vars = get_contact_search_vars( params[:searchbox_id] )
    if params[:searchbox_value] == "__search again__"
      render :update do |page|
        page.replace_html @search_vars[:id],
        :partial => 'searchbox_field'
      end
    else
      @contact = Contact.find( params[:searchbox_value] )
      render :update do |page|
        page.replace_html @search_vars[:display_id], :partial => 'display'
      end
    end
  end

  private

  def init_contact_search_vars
    seed = Time.now.to_i
    searchbox_id = "contact_searchbox_id_#{seed}"
    session[searchbox_id] = {}
    session[searchbox_id][:id]           = searchbox_id
    session[searchbox_id][:field_id]     = "#{searchbox_id}_field"
    session[searchbox_id][:display_id]   = "#{searchbox_id}_display"
    session[searchbox_id][:field_name]   = params[:field_name]   || 'contact_id'
    session[searchbox_id][:search_label] = params[:search_label] || "Search for a contact:"
    session[searchbox_id][:select_label] = params[:select_label] || "Choose a contact:"
    return session[searchbox_id]
  end

  def get_contact_search_vars(searchbox_id)
    return session[searchbox_id]
  end

end
