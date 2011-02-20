class VolunteerDefaultEvent < ActiveRecord::Base
  validates_presence_of :weekday_id
  belongs_to :weekday
  has_many :volunteer_default_shifts
  has_many :resources_volunteer_default_events
end
