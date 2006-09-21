module ContactMethodTypesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
     [ AjaxScaffold::ScaffoldColumn.new(ContactMethodType, 
        :name => 'parent_id', :label => 'Parent Type', 
        :eval => 'contact_method_type.parent.description', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(ContactMethodType, 
        :name => 'description'),
      ]
  end

end
