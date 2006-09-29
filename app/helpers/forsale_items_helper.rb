module ForsaleItemsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ AjaxScaffold::ScaffoldColumn.new(ForsaleItem, 
        :name => 'source_type_id', :label => 'Item location', 
        :eval => 'forsale_item.source_type', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(ForsaleItem, 
        :name => 'description'),
      AjaxScaffold::ScaffoldColumn.new(ForsaleItem, 
        :name => 'price'),
      AjaxScaffold::ScaffoldColumn.new(ForsaleItem, 
        :name => 'onhand_qty'),
      AjaxScaffold::ScaffoldColumn.new(ForsaleItem, 
        :name => 'taxable'),
    ]
  end

end
