module GizmoTypesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
     [ 
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'parent_id', :label => 'Parent Type', 
        :eval => 'gizmo_type.parent.description', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'description'),
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'fee'),
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'fee_is_required', :label => "Fee Required?",
        :eval => 'gizmo_type.fee_is_required ? "yes" : "no"'),
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'instantiable', :label => "Instantiable?",
        :eval => 'gizmo_type.instantiable ? "yes" : "no"'),
      ]
  end

end
module RelationshipTypesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
     [ AjaxScaffold::ScaffoldColumn.new(RelationshipType, 
        :name => 'description'),
      AjaxScaffold::ScaffoldColumn.new(RelationshipType, 
        :name => 'direction_matters', :label => "Does direction matter?",
        :eval => 'relationship_type.direction_matters ? "yes" : "no"'),
      ]
  end

end
