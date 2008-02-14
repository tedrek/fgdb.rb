class ContactsController < ApplicationController
  include DatalistFor
  ContactMethodsTag = 'contacts_contact_methods'
  layout :with_sidebar

  def index
    render :action => 'lookup'
  end

  def lookup
    @contact = Contact.find(params[:contact_id]) if params[:contact_id]
  end

  def search_results
    if params['contact_query']
      @search_results = Contact.search(params['contact_query'], :limit => 5)
    end
    render :layout => false, :partial => 'search_results', :locals => { :@search_results => @search_results, :options => params['options'] || { } }
  end

  def update_display_area
    @contact = Contact.find( params[:contact_id] )
    render :partial => 'display', :locals => { :@contact => @contact, :options => params['options'] }
  end

  def new
    @contact = Contact.new
    @contact.state_or_province = Default['state_or_province']
    @contact.city = Default['city']
    @contact.country = Default['country']
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

  #######
  private
  #######

  def _save
    @contact.contact_types = ContactType.find(params[:contact_types]) if params[:contact_types]
    success = @contact.save
    datalist_objects(ContactMethodsTag).each {|method|
      method.contact = @contact
      success &&= method.save
    }
    return success
  end
end
