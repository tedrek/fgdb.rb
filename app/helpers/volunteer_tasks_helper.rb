module VolunteerTasksHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [
      AjaxScaffold::ScaffoldColumn.new(VolunteerTask, :name => 'contact', :label => 'Volunteer Name',
        :eval => 'volunteer_task.contact', :sortable => false),
      AjaxScaffold::ScaffoldColumn.new(VolunteerTask, :name => 'duration'),
      AjaxScaffold::ScaffoldColumn.new(VolunteerTask, :name => 'date_performed'),
      AjaxScaffold::ScaffoldColumn.new(ContactType, :name => 'type', :label => 'Task Types',
        :eval => 'volunteer_task.volunteer_task_types.map {|t| t.description}.join(", ")', :sortable => false),
    ]
  end

end
