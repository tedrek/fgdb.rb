module DiscountSchedulesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(DiscountSchedule, 
                                       :name => 'name')
    ]
  end

end
