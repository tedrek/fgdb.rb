module SaleTxnsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'contact_id', :label => 'Purchaser', 
        :eval => 'contact.contact', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'till_handler_id', :label => 'Tiller', 
        :eval => 'till_handler.till_handler', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'gross_amount'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'discount_amount'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'tax_amount'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'amount_due'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'payment_method_id', :label => 'Payment method', 
        :eval => 'payment_method.payment_method', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'comments'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
        :name => 'is_refund'),
    ]
  end

end
