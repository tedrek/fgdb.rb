class ContactsController < ApplicationController
  include ContactsHelper
  
  def index
    redirect_to :action => 'search'
  end

  def search
    @search_vars = init_contact_search_vars
    @contact = params[:contact]
    @search_results = [ @contact ]
  end

  def search_results
    @search_vars = get_contact_search_vars( params[:searchbox_id] )
    @search_results = do_search( params[:query] )
    render :update do |page|
      page.replace_html @search_vars[:id], :partial => 'search_results'
    end
  end

  def update_display_area
    @search_vars = get_contact_search_vars( params[:searchbox_id] )
    @contact = Contact.find( params[:searchbox_value] )
    render :update do |page|
      page.replace_html @search_vars[:display_area_id], :partial => 'display'
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


  private

  def init_contact_search_vars
    seed = Time.now.to_i
    searchbox_id = "contact_searchbox_id_#{seed}"
    session[searchbox_id] = {}
    session[searchbox_id][:id] = searchbox_id
    session[searchbox_id][:field_id] = "#{searchbox_id}_field"
    session[searchbox_id][:select_id] = "#{searchbox_id}_select"
    session[searchbox_id][:display_area_id] = "#{searchbox_id}_display"
    session[searchbox_id][:field_name] = params[:field_name]   || 'contact_id'
    session[searchbox_id][:search_label] = params[:search_label] || "Search for a contact:"
    session[searchbox_id][:select_label] = params[:select_label] || "Choose a contact:"
    return session[searchbox_id]
  end

  def get_contact_search_vars(searchbox_id)
    return session[searchbox_id]
  end

  def do_search( query_str )
    # if the user added query wildcards, leave be if not, assume it's
    # better to bracket each word with wildcards
    unless query_str =~ /\*/
      query_str = query_str.split.map do |word|
        "*#{word}*" 
      end.join(' ')
    end
    @search_results = Contact.search( query_str, :limit => default_per_page )
    if @search_results.size == 0
      @search_vars[:notices] = "Your search for '#{query_str}' failed."
    elsif @search_results.size >= default_per_page
      @search_vars[:notices] = "Your search for '#{query_str}'
        returned too many results to disply.  You may want to
        refine your search."
    end
    return @search_results
  end

end
