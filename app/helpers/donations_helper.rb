module DonationsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'id'),
      AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'payment',
                                       :eval => 'donation.payment', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'donor', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(Donation, :name => 'created_at'),
    ]
  end

  def donation_contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

end
