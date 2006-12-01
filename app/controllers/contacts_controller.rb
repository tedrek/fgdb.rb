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
    when 'test'           then 'contacts.rhtml'
    when 'test_picklist'  then 'contacts.rhtml'
    else                        'contacts_search'
    end
  end

  def index
    redirect_to :action => 'test'
  end

  def test
    @contact = Contact.find( params[:contact_id] ) if params[:contact_id]
  end

  def search
    @search_results = [ @contact ] if( @contact = params[:contact] )
  end

  def search_results
    @search_results ||= do_search( params[:query] )
    render :update do |page|
      page.replace_html searchbox_search_results_div_id(params), :partial => 'search_results'
      page << "Field.focus('#{searchbox_select_id(params)}');" unless @search_results.empty?
    end
  end

  def update_display_area
    @contact = Contact.find( params[:searchbox_value] )
    render :update do |page|
      page.replace_html searchbox_display_id(params), :partial => 'display'
    end
  end

  def new
    @contact = Contact.new
    @successful = true
    render :action => 'new.rjs'
  end

  def create
    begin
      @contact = Contact.new(params[:contact])
      @contact.contact_types = ContactType.find(@params[:contact_types]) if @params[:contact_types]
      @successful = @contact.save
      save_datalist(ContactMethodsTag, :contact_id => @contact.id)
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
      @contact.contact_types = ContactType.find(@params[:contact_types]) if @params[:contact_types]
      @successful = @contact.update_attributes(params[:contact])
      save_datalist(ContactMethodsTag, :contact_id => @contact.id)
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

  def test_picklist
    render :partial => "test_picklist", :layout => true
  end

  def picklist
    begin
      @contact = Contact.find(3)
      #@contact = Contact.find(params[:id])
      @donations = @contact.donations
      @successful = @donations.size
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    render :action => "picklist.rjs"
  end

  def small_edit
    begin
      @contact = Contact.find(params[:id])
      @successful = !@contact.nil?
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    render :action => "small_edit.rjs"
  end

  def contact_formation
    params[:is_organization] = params[:is_organization] && params[:is_organization] != 'undefined'
    @show_type = params[:is_organization] ? 'organization' : 'person'
    @hide_type = params[:is_organization] ? 'person' : 'organization'
    render :action => "contact_formation.rjs"
  end

  private

  def do_search( query_str )
    begin
      if( params.has_key?( :limit_to_type ) and params[:limit_to_type] )
        @search_results = Contact.search_by_type( params[:limit_to_type], query_str, :limit => default_per_page )
      else
        @search_results = Contact.search( query_str, :limit => default_per_page )
      end
      if @search_results.size == 0
        flash[:error] = "Your search for '#{query_str}' failed."
      elsif @search_results.size >= default_per_page
        flash[:error] = "Your search for '#{query_str}' " +
          "returned too many results to display.  You may want to " +
          "refine your search."
      end
      return @search_results
    rescue
      flash[:error] = "Your search for '#{query_str}' failed atrociously."
      return []
    end
  end

end
