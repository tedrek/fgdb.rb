module GizmoEventsGizmoTypeattrsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(GizmoEventsGizmoTypeattr,
        :name => 'type', :label => 'Type',
        :eval => 'gizmo_events_gizmo_typeattr.gizmo_type',
        :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(GizmoEventsGizmoTypeattr,
        :name => 'event', :label => 'Event',
        :eval => 'gizmo_events_gizmo_typeattr.gizmo_event',
        :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(GizmoEventsGizmoTypeattr,
        :name => 'attr_val_text'),
      AjaxScaffold::ScaffoldColumn.new(GizmoEventsGizmoTypeattr,
        :name => 'attr_val_boolean'),
      AjaxScaffold::ScaffoldColumn.new(GizmoEventsGizmoTypeattr,
        :name => 'attr_val_monetary'),
      AjaxScaffold::ScaffoldColumn.new(GizmoEventsGizmoTypeattr,
        :name => 'attr_val_integer'),
    ]
  end

end
