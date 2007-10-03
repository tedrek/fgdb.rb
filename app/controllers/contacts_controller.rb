class ContactsController < ApplicationController
  layout :with_sidebar

  def index
    render :action => 'lookup'
  end

  def lookup
    @contact = Contact.find(params[:contact_id]) if params[:contact_id]
  end

  def search_results
    if params['contact_query']
      q = params['contact_query']
      if q.to_i > 0 and Contact.exists?(q)
        @search_results = Contact.find([q])
      else
        @search_results = Contact.search(q, :limit => 5)
      end
    end
    render :layout => false, :partial => 'search_results', :locals => { :@search_results => @search_results }
  end

  def update_display_area
    @contact = Contact.find( params[:searchbox_value] )
    render :partial => 'display'
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
    # TODO: Handle contact methods
    @contact.contact_types = ContactType.find(params[:contact_types]) if params[:contact_types]
    success = @contact.save
    return success
  end
end
