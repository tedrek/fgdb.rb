module DonationsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ AjaxScaffold::ScaffoldColumn.new(Donation, 
        :name => 'to_s', :label => 'Description', 
        :eval => 'donation.to_s', :sortable => false),
    ]
  end

  def donation_contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end
end
