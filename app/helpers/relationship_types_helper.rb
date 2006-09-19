module RelationshipTypesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    RelationshipType.scaffold_columns
  end

end
