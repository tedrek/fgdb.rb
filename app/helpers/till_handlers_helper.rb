module TillHandlersHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ AjaxScaffold::ScaffoldColumn.new(TillHandler, 
        :name => 'contact_id', :label => 'Contact', 
        :eval => 'till_handler.contact', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(TillHandler, 
        :name => 'description'),
      AjaxScaffold::ScaffoldColumn.new(TillHandler, 
        :name => 'can_alter_price'),
    ]
  end

end
