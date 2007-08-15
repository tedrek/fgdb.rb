class ContactsController < ApplicationController
  layout :with_sidebar

  active_scaffold :contact

  def results
    if params['query']
      q = params['query']
      if q.to_i > 0 and Contact.exists?(q)
        @contacts = Contact.find([q])
      else
        @contacts = Contact.search(q, :limit => 5)
      end
      render :layout => false if request.xhr?
    else
      redirect_to :action => 'search'
    end
  end

  include DatalistFor
  ContactMethodsTag = 'contacts_contact_methods'

  after_filter :clear_flashes
  
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

  def contact_formation
    params[:is_organization] = params[:is_organization] && params[:is_organization] != 'undefined'
    @show_type = params[:is_organization] ? 'organization' : 'person'
    @hide_type = params[:is_organization] ? 'person' : 'organization'
    render :action => "contact_formation.rjs"
  end

  private

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
