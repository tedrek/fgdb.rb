module VolunteerTasksHelper

  def num_columns
    scaffold_columns.length + 1
  end

  def scaffold_columns
    [
     Column.new(VolunteerTask, :name => 'contact', :label => 'Volunteer Name',
                :eval => 'volunteer_task.contact', :sortable => false),
     Column.new(VolunteerTask, :name => 'duration'),
     Column.new(VolunteerTask, :name => 'date_performed'),
     Column.new(ContactType, :name => 'type', :label => 'Task Types',
                :eval => 'volunteer_task.volunteer_task_types.map {|t| t.description}.join(", ")', :sortable => false),
    ]
  end

  def task_form_id
    "volunteer_tasks_by_volunteer_form"
  end

end
