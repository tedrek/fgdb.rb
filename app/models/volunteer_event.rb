class VolunteerEvent < ActiveRecord::Base
  validates_presence_of :date
  has_many :volunteer_shifts
  has_many :resources_volunteer_events

  def date_anchor
    self.date.strftime('%Y%m%d')
  end

  def time_range_s
    my_start_time = self.volunteer_shifts.sort_by(&:start_time).first.start_time
    my_end_time = self.volunteer_shifts.sort_by(&:end_time).last.end_time
    (my_start_time.strftime("%I:%M") + ' - ' + my_end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def copy_to(date, time_shift)
    new = self.class.new(self.attributes)
    new.volunteer_shifts = self.volunteer_shifts.map{|x| x.class.new(x.attributes)}
#    new.resources = self.resources.map{|x| x.class.new(x.attributes)}
    new.date = date
    new.volunteer_shifts.each{|x| x.time_shift(time_shift)}
#    new.resources.each{|x| x.time_shift(time_shift)}
    new.save!
    new.volunteer_shifts.each{|x| x.save!}
    return new
  end
end
