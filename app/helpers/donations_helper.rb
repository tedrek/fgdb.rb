module DonationsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ AjaxScaffold::ScaffoldColumn.new(Donation, 
        :name => 'donor', :label => 'Donor', 
        :eval => 'donation.donor', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(Donation, 
        :name => 'money_tendered'),
      AjaxScaffold::ScaffoldColumn.new(Donation, 
        :name => 'payment_method_id', :label => 'Payment method', 
        :eval => 'donation.payment_method', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(Donation, 
        :name => 'created_at'),
    ]
  end

  def donation_contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end
end
