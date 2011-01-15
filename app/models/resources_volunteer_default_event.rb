class ResourcesVolunteerDefaultEvent < ActiveRecord::Base
  belongs_to :resource
  belongs_to :volunteer_default_event
end
