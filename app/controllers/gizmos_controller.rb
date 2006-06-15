class GizmosController < ApplicationController
  include AjaxScaffold::Controller
  
  after_filter :clear_flashes
  
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
    if request.xhr?
      # If this is an AJAX request then we just want to delegate to the component to rerender itself
      component
    else
      # If this is from a client without javascript we want to update the session parameters and then delegate
      # back to whatever page is displaying the scaffold, which will then rerender all scaffolds with these update parameters
      update_params :default_scaffold_id => "gizmo", :default_sort => nil, :default_sort_direction => "asc"
      return_to_main
    end
  end

  def component
    update_params :default_scaffold_id => "gizmo", :default_sort => nil, :default_sort_direction => "asc"
     
    @sort_sql = Gizmo.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{Gizmo.table_name}.#{Gizmo.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @gizmos = paginate(:gizmos, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @class_trees = ClassTree.find(:all, :conditions => ["instantiable = ?", true], :order => 'description')
    @gizmo = Gizmo.new
    @successful = true

    return render :action => 'new.rjs' if request.xhr?

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
      @gizmo = Gizmo.new(params[:gizmo])
      @successful = @gizmo.save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'create.rjs' if request.xhr?
    if @successful
      return_to_main
    else
      @options = { :scaffold_id => params[:scaffold_id], :action => "create" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def edit
    begin
      @class_trees = ClassTree.find(:all, :conditions => ["instantiable = ?", true], :order => 'description')
      @gizmo = Gizmo.find(params[:id])
      @successful = !@gizmo.nil?
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'edit.rjs' if request.xhr?

    if @successful
      @options = { :scaffold_id => params[:scaffold_id], :action => "update", :id => params[:id] }
      render :partial => 'new_edit', :layout => true
    else
      return_to_main
    end    
  end

  def update
    begin
      @gizmo = Gizmo.find(params[:id])
      @successful = @gizmo.update_attributes(params[:gizmo])
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'update.rjs' if request.xhr?

    if @successful
      return_to_main
    else
      @options = { :action => "update" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def destroy
    begin
      @successful = Gizmo.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render :action => 'destroy.rjs' if request.xhr?
    
    # Javascript disabled fallback
    return_to_main
  end
  
  def cancel
    @successful = true
    
    return render :action => 'cancel.rjs' if request.xhr?
    
    return_to_main
  end
end
