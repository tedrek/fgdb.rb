module TransactionHelper
  include AjaxScaffold::Helper
  
  def num_columns(context)
    scaffold_columns(context).length + 1 
  end
  
  def scaffold_columns(context)
    case context
    when 'sale'
      [
       AjaxScaffold::ScaffoldColumn.new(SaleTxn, :name => 'id', :eval => 'sale.id'),
       AjaxScaffold::ScaffoldColumn.new(SaleTxn, :name => 'payment',
                                        :eval => 'sale.payment', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(SaleTxn, :name => 'buyer', :sortable => false, :eval => 'sale.buyer'),
       AjaxScaffold::ScaffoldColumn.new(SaleTxn, :name => 'created_at', :eval => 'sale.created_at'),
      ]
    when 'donation'
      [
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'id'),
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'payment',
                                        :eval => 'donation.payment', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'donor', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'created_at'),
      ]
    end
  end

  def donation_contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def sale_contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def totals_id(context)
    context + "_totals_div"
  end
end
