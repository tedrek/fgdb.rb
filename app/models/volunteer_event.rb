class VolunteerEvent < ActiveRecord::Base
  validates_presence_of :date
  has_many :volunteer_shifts
end
