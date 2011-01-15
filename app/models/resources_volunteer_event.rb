class ResourcesVolunteerEvent < ActiveRecord::Base
  belongs_to :resource
  belongs_to :volunteer_event
  belongs_to :resources_volunteer_default_event
end
