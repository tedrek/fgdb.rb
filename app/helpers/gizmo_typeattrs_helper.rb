module GizmoTypeattrsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(GizmoTypeattr, 
        :name => 'gizmo_type', :label => 'gizmo_type', 
        :eval => 'gizmo_typeattr.gizmo_type', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(GizmoTypeattr, 
        :name => 'gizmo_attr', :label => 'gizmo_attr', 
        :eval => 'gizmo_typeattr.gizmo_attr', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(GizmoTypeattr, 
        :name => 'validation_callback', :label => 'validation_callback', 
        :eval => 'gizmo_typeattr.validation_callback', :sortable => false),
    ]
  end

end
