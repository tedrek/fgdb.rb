class VolunteerShift < ActiveRecord::Base
  validates_presence_of :volunteer_task_type_id, :unless => Proc.new { |shift| shift.class_credit }
  validates_presence_of :roster_id
  validates_presence_of :end_time
  validates_presence_of :start_time

  belongs_to :volunteer_task_type
  has_many :assignments
  belongs_to :program
  belongs_to :roster

  belongs_to :volunteer_event

#  before_validation :set_values_if_stuck # integrate with fill_in_available? might be less buggy that way. yeah.
  def set_values_if_stuck
    return unless self.stuck_to_assignment
    self.start_time = self.assignments.first.start_time
    self.end_time = self.assignments.first.end_time
  end

  def skedj_style(overlap, last)
    overlap ? 'hardconflict' : 'shift'
  end

  def time_range_s
    return unless self.read_attribute(:start_time) and  self.read_attribute(:end_time)
    (self.my_start_time("%I:%M") + ' - ' + self.my_end_time("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def my_start_time(format = "%H:%M")
    read_attribute(:start_time).strftime(format)
  end

  def self._parse_time(time)
    Time.mktime(2000, 01, 01, *time.split(":").map(&:to_i))
  end

  def my_start_time=(str)
    write_attribute(:start_time, VolunteerShift._parse_time(str))
  end

  def my_end_time(format = "%H:%M")
    read_attribute(:end_time).strftime(format)
  end

  def my_end_time=(str)
    write_attribute(:end_time, VolunteerShift._parse_time(str))
  end

  def fill_in_available
    Thread.current['volskedj_fillin_processing'] ||= []
    if Thread.current['volskedj_fillin_processing'].include?(self.id)
      return
    end
    begin
      Thread.current['volskedj_fillin_processing'].push(self.id)
      Assignment.find_all_by_volunteer_shift_id(self.id).select{|x| x.contact_id.nil?}.each{|x| x.destroy}
      inputs = [[time_to_int(self.read_attribute(:start_time)), time_to_int(self.read_attribute(:end_time))]]
      Assignment.find_all_by_volunteer_shift_id(self.id).select{|x| !x.cancelled?}.each{|x|
        inputs.push([time_to_int(x.start_time), time_to_int(x.end_time)])
      }
      results = range_math(*inputs)
      results = results.map{|a| a.map{|x| int_to_time(x)}}
      results.each{|x|
        a = Assignment.new
        a.volunteer_shift_id, a.start_time, a.end_time = self.id, x[0], x[1]
        a.save!
      }
    ensure
      Thread.current['volskedj_fillin_processing'].delete(self.id)
    end
  end

  after_save :fill_in_available

  def date
    self.volunteer_event.date
  end

  def date_display
    self.date.strftime('%A, %B %d, %Y').gsub( ' 0', ' ' )
  end

  def date_anchor
    self.date.strftime('%Y%m%d')
  end

  def time_shift(val)
    self.start_time += val
    self.end_time += val
  end

  def left_method_name
    [self.volunteer_task_type_id.nil? ? self.volunteer_event.description : self.volunteer_task_type.description, self.slot_number].select{|x| !x.nil?}.join(", ")
  end

  def left_unique_value
    left_method_name
  end

  def description_and_slot
    ((self.volunteer_task_type_id || -1) * 1000) + self.slot_number
  end

  def weekday
    Weekday.find_by_id(self.date.strftime("%w"))
  end
end
