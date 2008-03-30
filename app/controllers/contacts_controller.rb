class ContactsController < ApplicationController
  include DatalistFor
  ContactMethodsTag = 'contacts_contact_methods'
  layout :with_sidebar

  around_filter :transaction_wrapper
  before_filter :authorized_only

  class ForceRollback < RuntimeError
  end

  #########
  protected

  def transaction_wrapper
    Contact.transaction do
      yield
      raise ForceRollback.new if flash[:error]
    end
    rescue ForceRollback
  end

  def authorized_only
    #     if params[:id]
    #       contact_id = params[:id].to_i
    #     elsif params[:contact_id]
    #       contact_id = params[:id].to_i
    #     else
    #       contact_id = nil
    #     end
    #     requires_role_or_me(contact_id, 'ROLE_CONTACT_MANAGER')
    requires_role('ROLE_CONTACT_MANAGER', 'ROLE_FRONT_DESK', 'ROLE_STORE', 'ROLE_VOLUNTEER_MANAGER')
  end

  ######
  public

  def index
    render :action => 'lookup'
  end

  def lookup
  end

  def search_results
    if params['contact_query']
      @search_results = Contact.search(params['contact_query'], :limit => 10)
    end
    render :layout => false, :partial => 'search_results', :locals => { :@search_results => @search_results, :options => params['options'] || {} }
  end

  def update_display_area
    @contact = Contact.find( params.fetch(:contact_id, '').strip )
    render :partial => 'display', :locals => { :@contact => @contact, :options => params['options'] || params}
  end

  def new
    @contact = Contact.new
    @contact.state_or_province = Default['state_or_province']
    @contact.city = Default['city']
    @contact.country = Default['country']
    @options = params.merge({:action => "create", :id => rand(1000).to_s * 10})
    @new_options = @options.merge(:action => "new", :id => nil)
    @successful = true
    #render :action => 'new.rjs'
    render :partial => 'new_edit', :locals => { :@options => @options }
  end

  def create
    begin
      @contact = Contact.new(params[:contact])

      if params[:contact][:is_user].to_i != 0
        if !has_role?(:ROLE_ADMIN)
          raise RuntimeError.new("You are not authorized to create a user login")
        end
        @contact.user = User.new(params[:user])
        @contact.user.roles = Role.find(params[:roles]) if params[:roles]
      end
      @user = @contact.user
      @successful = _save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end

    render :action => 'create.rjs'
  end

  def edit
    begin
      @contact = Contact.find(params[:id])
      @user = @contact.user or User.new
      @successful = !@contact.nil?
    rescue
      flash[:error], @successful  = $!.to_s, false
    end

    @options = params.merge({ :action => "update", :id => params[:id] })
    @view_options = @options.merge(:action => "view")
    render :partial => 'new_edit', :locals => { :@options => @options }
    #render :action => 'edit.rjs'
  end

  def update
    begin
      @contact = Contact.find(params[:id])
      @contact.attributes = params[:contact]
      if has_role_or_is_me?(@contact.id, :ROLE_ADMIN)
        if (params[:contact][:is_user].to_i != 0)
          @contact.user = User.new if !@contact.user
          @contact.user.attributes = params[:user]
          @contact.user.roles = Role.find(params[:roles]) if params[:roles] && has_role?(:ROLE_ADMIN) 
        elsif (@contact.user)
          @contact.user.destroy
          @contact.user = nil
        end
      end
      @user = @contact.user
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

  def method_missing(symbol, *args)
    if /auto_complete_for_(.*)_query/.match(symbol.to_s)
      @contacts = Contact.search(params[$1][:query].strip, :limit => 10)
      render :partial => 'auto_complete_list'
    else
      super
    end
  end

  #######
  private
  #######

  def _save
    @contact.contact_types = ContactType.find(params[:contact_types]) if params[:contact_types]
    success = @contact.save
    if datalist_objects(ContactMethodsTag)
      datalist_objects(ContactMethodsTag).each {|method|
        method.contact = @contact
        success &&= method.save
      }
    end
    if @contact.user
      success &&= @contact.user.save
    end
    return success
  end
end
