module SaleTxnsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ AjaxScaffold::ScaffoldColumn.new(Donation, 
        :name => 'to_s', :label => 'Description', 
        :eval => 'sale_txn.to_s', :sortable => false),
      #       AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
      #         :name => 'contact_id', :label => 'Purchaser', 
      #         :eval => 'contact.contact', :sortable => false),
      #       AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
      #         :name => 'money_tendered'),
      #       AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
      #         :name => 'discount_amount'),
      #       AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
      #         :name => 'amount_due'),
      #       AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
      #         :name => 'payment_method_id', :label => 'Payment method', 
      #         :eval => 'payment_method.payment_method', :sortable => false),
      #       AjaxScaffold::ScaffoldColumn.new(SaleTxn, 
      #        :name => 'comments'),
    ]
  end

  def sale_txn_contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end

end
