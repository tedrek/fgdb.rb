class ContactsController < ApplicationController
  include AjaxScaffold::Controller
  include ContactsHelper
  include DatalistFor
  ContactMethodsTag = 'contacts_contact_methods'

  after_filter :clear_flashes
  before_filter :update_params_filter
  
  def update_params_filter
    update_params( :default_scaffold_id => "contacts_" + generate_temporary_id )
    session[@scaffold_id] = { :search_label => 'Search for a contact',
      :select_label => 'Choose a contact',
      :select_name => 'contact_id' }.merge( session[@scaffold_id] )
    store_or_get_from_session(@scaffold_id, :search_label)
    store_or_get_from_session(@scaffold_id, :select_name)
    store_or_get_from_session(@scaffold_id, :select_label)
  end

  layout :contact_layout_choice

  def contact_layout_choice
    case action_name
    when 'lookup' then 'with_sidebar.rhtml'
    else               'contacts_search'
    end
  end

  def index
    redirect_to :action => 'lookup'
  end

  def lookup
    @contact = Contact.find( params[:contact_id] ) if params[:contact_id]
  end

  def search
    @search_results = [ @contact ] if( @contact = params[:contact] )
  end

  def search_results
    @search_results ||= do_search( params[:query] )
    render :action => 'search_results.rjs'
  end

  def update_display_area
    @contact = Contact.find( params[:searchbox_value] )
    render :update do |page|
      page.replace_html searchbox_display_id(params), :partial => 'display'
    end
  end

  def new
    @contact = Contact.new
    @contact.state_or_province = 'OR'
    @contact.city = 'Portland'
    @successful = true
    render :action => 'new.rjs'
  end

  def create
    begin
      @contact = Contact.new(params[:contact])
      @successful = _save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    render :action => 'create.rjs'
  end

  def edit
    begin
      @contact = Contact.find(params[:id])
      @successful = !@contact.nil?
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    render :action => 'edit.rjs'
  end

  def update
    begin
      @contact = Contact.find(params[:id])
      @contact.attributes = params[:contact]
      @successful = _save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    render :action => 'update.rjs'
  end

  def destroy
    begin
      @successful = Contact.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    render :action => 'destroy.rjs'
  end

  def cancel
    @successful = true
    render :action => 'cancel.rjs'
  end

  def contact_formation
    params[:is_organization] = params[:is_organization] && params[:is_organization] != 'undefined'
    @show_type = params[:is_organization] ? 'organization' : 'person'
    @hide_type = params[:is_organization] ? 'person' : 'organization'
    render :action => "contact_formation.rjs"
  end

  private

  def do_search( query_str )
    default_per_page = 40
    begin
      if query_str.to_i.to_s == query_str
	@search_results = [Contact.find(query_str)]
      elsif params[:limit_to_type]
        @search_results = Contact.search_by_type( params[:limit_to_type], query_str, :limit => default_per_page )
      else
        @search_results = Contact.search( query_str, :limit => default_per_page )
      end
      if @search_results.size == 0
        if params[:limit_to_type]
          flash[:error] = "Your search for '#{query_str}' found no #{params[:limit_to_type]}s."
        else
          flash[:error] = "Your search for '#{query_str}' found no results."
        end
      elsif @search_results.size >= default_per_page
        flash[:error] = "Your search for '#{query_str}' " +
          "returned too many results to display.  You may want to " +
          "refine your search."
      end
      @search_results = @search_results.sort_by {|c| c.display_name}
      return @search_results
    rescue
      flash[:error] = "Your search for '#{query_str}' failed atrociously.<br />#{$!.to_s}<br />#{$!.backtrace.join "<br />"}"
      return []
    end
  end

  #######
  private
  #######

  def _save
    @contact.contact_types = ContactType.find(@params[:contact_types]) if @params[:contact_types]
    success = @contact.save
    datalist_objects(ContactMethodsTag).each {|method|
      method.contact = @contact
      success &&= method.save
    }
    return success
  end
end
