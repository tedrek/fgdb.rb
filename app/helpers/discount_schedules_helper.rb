module DiscountSchedulesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(DiscountSchedule, 
        :name => 'resale_item_rate'),
      AjaxScaffold::ScaffoldColumn.new(DiscountSchedule, 
        :name => 'donated_item_rate'),
      AjaxScaffold::ScaffoldColumn.new(DiscountSchedule, 
        :name => 'short_name'),
      AjaxScaffold::ScaffoldColumn.new(DiscountSchedule, 
        :name => 'description'),
    ]
  end

end
