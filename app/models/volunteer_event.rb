class VolunteerEvent < ActiveRecord::Base
  validates_presence_of :date
  has_many :volunteer_shifts
  has_many :resources_volunteer_events
end
