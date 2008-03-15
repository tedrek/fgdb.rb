class ContactsController < ApplicationController
  include DatalistFor
  ContactMethodsTag = 'contacts_contact_methods'
  layout :with_sidebar

  around_filter :transaction_wrapper

  class ForceRollback < RuntimeError
  end

  def transaction_wrapper
    Contact.transaction do
      yield
      raise ForceRollback.new if flash[:error]
    end
    rescue ForceRollback
  end

  def index
    render :action => 'lookup'
  end

  def lookup
    test = params[params[:contact_element_prefix]] ? 'true' : 'false'
    query = params[params[:contact_element_prefix]] ? params[params[:contact_element_prefix]][:query] : ''
    @thing = "thing"
    @thing.instance_eval "
      def query
        if #{test}
          Contact.find('#{query.gsub(/[^0-9]/, '')}')
        end
      end
      alias :contact :query
    "
    instance_variable_set("@" + params[:contact_element_prefix], @thing) if params[:contact_element_prefix]
  end

  def search_results
    if params['contact_query']
      @search_results = Contact.search(params['contact_query'], :limit => 10)
    end
    render :layout => false, :partial => 'search_results', :locals => { :@search_results => @search_results, :options => params['options'] || {} }
  end

  def update_display_area
    @contact = Contact.find( params[:contact_id].strip )
    render :partial => 'display', :locals => { :@contact => @contact, :options => params['options'] || params}
  end

  def boxtest
    render :text => %Q[<p>meow<a href="#" class="lightwindow_action" rel="deactivate">Cancel</a></p>]
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

    render :action => 'edit.rjs'
  end

  def update
    begin
      @contact = Contact.find(params[:id])
      @contact.attributes = params[:contact]
      if has_role_or_is_me?(@contact.id, :ROLE_ADMIN)
        if (params[:contact][:is_user].to_i != 0)
          @contact.user = User.new if !@contact.user
          @contact.user.attributes = params[:user]
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

  def auto_complete_for_contact_query(name=nil)
    name ||= 'contact'
    @contacts = Contact.search(params[name][:query].strip, :limit => 10)
    render :partial => 'auto_complete_list'
  end

  #######
  private
  #######

  def method_missing(symbol, *args)
    if /auto_complete_for_(.*)_query/.match(symbol.to_s)
      auto_complete_for_contact_query($1)
      render :action => :auto_complete_for_contact_query
    else
      super
    end
  end

  def _save
    @contact.contact_types = ContactType.find(params[:contact_types]) if params[:contact_types]
    success = @contact.save
    datalist_objects(ContactMethodsTag).each {|method|
      method.contact = @contact
      success &&= method.save
    }
    if @contact.user
      success &&= @contact.user.save
    end
    return success
  end
end
