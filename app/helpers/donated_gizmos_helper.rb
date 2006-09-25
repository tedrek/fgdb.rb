module DonatedGizmosHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(DonatedGizmo, 
        :name => 'gizmo_type_id', :label => 'Donated gizmo type', 
        :eval => 'donated_gizmo.gizmo_type', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(DonatedGizmo, 
        :name => 'quantity'),
      AjaxScaffold::ScaffoldColumn.new(DonatedGizmo, 
        :name => 'donation_id', :label => 'Donation Id', 
        :eval => 'donated_gizmo.donation', :sortable => false),
    ]
  end

end
