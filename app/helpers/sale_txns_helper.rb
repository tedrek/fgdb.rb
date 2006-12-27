module SaleTxnsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, :name => 'money_tendered',
                                       :eval => '"$%0.2f %s" % [ sale_txn.money_tendered, sale_txn.payment_method.description ]'),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, :name => 'buyer', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(SaleTxn, :name => 'created_at'),
    ]
  end

  def sale_txn_contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

end
