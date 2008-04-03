module VolunteerTasksHelper
  include ApplicationHelper

  def columns
    [
     Column.new(VolunteerTask, :name => 'contact', :label => 'Volunteer Name',
                :eval => 'volunteer_task.contact.display_name', :sortable => false),
     Column.new(VolunteerTask, :name => 'duration'),
     Column.new(VolunteerTask, :name => 'date_performed'),
     Column.new(ContactType, :name => 'task_type', :label => 'Task Type',
                :eval => 'volunteer_task.volunteer_task_type.display_name', :sortable => false),
     Column.new(ContactType, :name => 'service_type', :label => 'Community Service Type',
                :eval => 'volunteer_task.community_service_type.display_name', :sortable => false),
    ]
  end

  def task_form_id
    "volunteer_tasks_by_volunteer_form"
  end

end
