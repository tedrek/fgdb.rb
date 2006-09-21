module ContactMethodsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ AjaxScaffold::ScaffoldColumn.new(ContactMethod, 
        :name => 'contact_method_type_id', :label => 'Contact method type', 
        :eval => 'contact_method.contact_method_type', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(ContactMethod, 
        :name => 'description'),
      AjaxScaffold::ScaffoldColumn.new(ContactMethod, 
        :name => 'ok'),
    ]
  end

end
