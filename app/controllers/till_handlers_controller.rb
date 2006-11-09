class TillHandlersController < ApplicationController
  include AjaxScaffold::Controller
  
  after_filter :clear_flashes
  before_filter :update_params_filter
  
  def update_params_filter
    update_params :default_scaffold_id => "till_handler", :default_sort => nil, :default_sort_direction => "asc"
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
    @sort_sql = TillHandler.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{TillHandler.table_name}.#{TillHandler.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @till_handlers = paginate(:till_handlers, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @till_handler = TillHandler.new
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
      @till_handler = TillHandler.new(params[:till_handler])
      @successful = @till_handler.save
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
      @till_handler = TillHandler.find(params[:id])
      @successful = !@till_handler.nil?
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
      @till_handler = TillHandler.find(params[:id])
      @successful = @till_handler.update_attributes(params[:till_handler])
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
      @successful = TillHandler.find(params[:id]).destroy
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

  # drop receiver testing
  def droppad
    session[:dropped] ||= {}
    @contacts = Contact.find(:all)
  end
  
  def add
    id =   params[:id].split("_")[1]
    type = params[:id].split("_")[0]
    
    session[:dropped][type.to_sym] ||= {}
    session[:dropped][type.to_sym][id] = 
      session[:dropped][type.to_sym].include?(id) ?  
      session[:dropped][type.to_sym][id]+1 : 1
  
    #render :partial => 'dp_contents'
    new_w_contact(id) if type == 'contact'
  end

  def new_w_contact(id = nil)
    new if id.nil?
    @till_handler = TillHandler.new
    @till_handler.contact_id = id
    @successful = true
    #return render(:action => 'new.rjs') if request.xhr?
    @options = { :action => 'create', :id => 9999 }
    @new_options = @options.merge(:action=>'new', :id=>nil)
    return render(:partial => 'new_edit') if request.xhr?
  end
end
