module TransactionHelper
  include AjaxScaffold::Helper
  
  def num_columns(context)
    scaffold_columns(context).length + 1 
  end
  
  def scaffold_columns(context)
    case context
    when 'sale'
      [
       AjaxScaffold::ScaffoldColumn.new(Sale, :name => 'id', :eval => 'sale.id'),
       AjaxScaffold::ScaffoldColumn.new(Sale, :name => 'payment',
                                        :eval => 'sale.payment', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Sale, :name => 'buyer', :sortable => false, :eval => 'sale.buyer'),
       AjaxScaffold::ScaffoldColumn.new(Sale, :name => 'created_at', :eval => 'sale.created_at'),
      ]
    when 'donation'
      [
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'id'),
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'payment',
                                        :eval  => 'donation.payment', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'donor', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'created_at'),
      ]
    when 'dispersement'
      [
       AjaxScaffold::ScaffoldColumn.new(Dispersement, :name => 'id'),
       AjaxScaffold::ScaffoldColumn.new(Dispersement, :name => 'dispersement_type', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Dispersement, :name => 'recipient', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Dispersement, :name => 'gizmos', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Dispersement, :name => 'dispersed_at'),
      ]
    when 'recycling'
      [
       AjaxScaffold::ScaffoldColumn.new(Recycling, :name => 'gizmos', :sortable => false),
       AjaxScaffold::ScaffoldColumn.new(Recycling, :name => 'recycled_at'),
      ]
    end
  end

  def contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def totals_id(context)
    context + "_totals_div"
  end
end
