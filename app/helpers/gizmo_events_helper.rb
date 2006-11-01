module GizmoEventsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(GizmoEvent, 
        :name => 'gizmo_context_id', :label => 'Gizmo Event context', 
        :eval => 'gizmo_event.gizmo_context', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(GizmoEvent, 
        :name => 'gizmo_count'),
      AjaxScaffold::ScaffoldColumn.new(GizmoEvent, 
        :name => 'gizmo_type_id', :label => 'Gizmo Event type', 
        :eval => 'gizmo_event.gizmo_type', :sortable => false),
    ]
  end

end
