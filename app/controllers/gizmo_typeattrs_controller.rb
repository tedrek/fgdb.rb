class GizmoTypeattrsController < ApplicationController
  include AjaxScaffold::Controller
  
  after_filter :clear_flashes
  before_filter :update_params_filter
  
  def update_params_filter
    update_params :default_scaffold_id => "gizmo_typeattr", :default_sort => nil, :default_sort_direction => "asc"
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
    @sort_sql = GizmoTypeattr.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{GizmoTypeattr.table_name}.#{GizmoTypeattr.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @gizmo_typeattrs = paginate(:gizmo_typeattrs, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @gizmo_typeattr = GizmoTypeattr.new
    @context_checkbox = checkbox_collection('gizmo_typeattr','gizmo_context', @gizmo_typeattr, GizmoContext.find_all_for_select)
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
      @gizmo_typeattr = GizmoTypeattr.new(params[:gizmo_typeattr])
      @successful = @gizmo_typeattr.save
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
      @gizmo_typeattr = GizmoTypeattr.find(params[:id])
      @context_checkbox = checkbox_collection('gizmo_typeattr','gizmo_context', @gizmo_typeattr, GizmoContext.find_all_for_select)
      @successful = !@gizmo_typeattr.nil?
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
      @gizmo_typeattr = GizmoTypeattr.find(params[:id])
      @successful = @gizmo_typeattr.update_attributes(params[:gizmo_typeattr])
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
      @successful = GizmoTypeattr.find(params[:id]).destroy
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

  # checkbox_collection
  # create a set of checkboxes for updating a habtm
  # relationship
  # source: http://exdolo.com/2006/8/8/habtm-checkbox-helper
  #
  # imagine you have a Role and User model with a habtm
  # relationship.
  # given an @user object for the current user and a collection
  # of all roles in @roles:
  #
  # checkbox_collection("user","role", @user, @roles.collect{|r| [r.title,r.id]})
  #
  # the collection parameter expects an array of arrays with the
  # label as the first member in an element array and it's value
  # as the last. 
  def checkbox_collection(objekt,method,instance,collection)
    m2m = instance.send("#{method}s".to_sym)
    name_string = "#{objekt}[#{method}_ids][]" 
    collection.map do |item|
      id_string = "#{objekt}_#{method}_#{item.last}" 
      tag_options = {
        "type" => "checkbox", 
        "name" => name_string,
        "id" => id_string,
        "value" => item.last
      }
      tag_options["checked"] = "checked" if m2m.collect{|a| a.id}.include?  item.last
      #content_tag("li", tag("input", tag_options) + content_tag("label",item.first,"for" => id_string))
      #ActionView::Helpers::TagHelper.content_tag("li", "<input type=\"checkbox\" value=\"<%= item.last %>\" /> " + ActionView::Helpers::TagHelper.content_tag("label",item.first,"for" => id_string))
      checked_var =  tag_options["checked"].nil? ? '' : 'checked="checked"'
      "<li><input  checked_var name=\"#{name_string}\" id=\"#{id_string}\" type=\"checkbox\" value=\"#{item.last}\" /> " + 
        "<label for=\"#{id_string}\">#{item.first}</label>"
    end.join("\n")
  end 
end
