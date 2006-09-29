module SaleTxnLinesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'sale_txn_id'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'forsale_item_id', :label => 'Item', 
        :eval => 'forsale_item.forsale_item', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'base_price'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'quantity'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'extended_price'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'discount_applied'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'tax_applied'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'net_price'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'taxable'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'comments'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'standard_extended_discount'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxnLine, 
        :name => 'is_refund'),
    ]
  end

end
