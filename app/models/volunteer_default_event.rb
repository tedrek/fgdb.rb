class VolunteerDefaultEvent < ActiveRecord::Base
  validates_presence_of :weekday_id
  belongs_to :weekday
  has_many :volunteer_default_shifts
  has_many :resources_volunteer_default_events

  def copy_to(weekday, time_shift)
    new = self.class.new(self.attributes)
    new.volunteer_default_shifts = self.volunteer_default_shifts.map{|x| x.class.new(x.attributes)}
#    new.resources = self.resources.map{|x| x.class.new(x.attributes)}
    new.weekday = weekday
    new.volunteer_default_shifts.each{|x| x.time_shift(time_shift)}
#    new.resources.each{|x| x.time_shift(time_shift)}
    new.save!
    new.volunteer_default_shifts.each{|x| x.save!}
    return new
  end
end
