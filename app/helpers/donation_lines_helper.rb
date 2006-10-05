module DonationLinesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(DonatedGizmo, 
        :name => 'gizmo_event_id'),
    ]
  end

end
