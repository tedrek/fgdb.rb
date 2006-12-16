# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  layout "application"
  include DatebocksEngine

  # For gizmo_events embedded in a form
  def add_attrs_to_form
    if params[:gizmo_type_id]
      @gizmo_context = GizmoContext.find(params[:gizmo_context_id])
      @gizmo_type = GizmoType.find(params[:gizmo_type_id])
      if ! @gizmo_type.relevant_attrs(@gizmo_context).empty?
        render :update do |page|
          page.replace_html params[:div_id], :partial => 'gizmo_event_attr_form', :locals => { :params => params }
        end
        return true
      end
    end
    render :update do |page|
    end
  end

end
