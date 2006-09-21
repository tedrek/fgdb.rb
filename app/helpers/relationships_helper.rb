module RelationshipsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
     [ AjaxScaffold::ScaffoldColumn.new(Relationship, 
        :name => 'source', :label => 'Source', 
        :eval => 'relationship.source', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(Relationship, 
        :name => 'type', :label => 'Type', 
        :eval => 'relationship.relationship_type', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(Relationship, 
        :name => 'sink', :label => 'Sink', 
        :eval => 'relationship.sink', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(Relationship, 
        :name => 'flow?'),
      ]
  end

end
