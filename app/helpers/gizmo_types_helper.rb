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
        :name => 'required_fee'),
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'suggested_fee'),
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'discounts',
        :eval => 'gizmo_type.displayed_discounts',
        :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(GizmoType, 
        :name => 'context', :label => 'Context(s)', 
        :eval => 'gizmo_type.gizmo_contexts.map {|c| c.abbrev}.sort.join(",")', 
        :sortable => false),
      ]
  end

end
