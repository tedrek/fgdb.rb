module ContactTypesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(ContactType, :name => 'description'),
      AjaxScaffold::ScaffoldColumn.new(ContactType, :name => 'for_who'),
    ]
  end

end
