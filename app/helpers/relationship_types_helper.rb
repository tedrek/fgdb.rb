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
