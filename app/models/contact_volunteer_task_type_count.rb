class ContactVolunteerTaskTypeCount < ActiveRecord::Base
  belongs_to :contact
  belongs_to :volunteer_task_type
end
