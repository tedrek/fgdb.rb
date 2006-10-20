module GizmoAttrsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(GizmoAttr, 
        :name => 'name'),
      AjaxScaffold::ScaffoldColumn.new(GizmoAttr, 
        :name => 'datatype'),
    ]
  end

end
