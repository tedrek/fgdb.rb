module VolunteerTaskTypesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(VolunteerTaskType, :name => 'description'),
      AjaxScaffold::ScaffoldColumn.new(VolunteerTaskType, :name => 'parent',
                                       :eval => 'volunteer_task_type.parent.description',
                                       :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(VolunteerTaskType, :name => 'hours_multiplier'),
      AjaxScaffold::ScaffoldColumn.new(VolunteerTaskType, :name => 'instantiable'),
      AjaxScaffold::ScaffoldColumn.new(VolunteerTaskType, :name => 'required'),
    ]
  end

end
