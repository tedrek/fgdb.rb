class VolunteerDefaultEvent < ActiveRecord::Base
  validates_presence_of :weekday_id
  belongs_to :weekday
end
