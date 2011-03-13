class Assignment < ActiveRecord::Base
  belongs_to :volunteer_shift
  has_one :volunteer_task_type, :through => :volunteer_shift, :source => :volunteer_task_type
  belongs_to :contact
  validates_presence_of :volunteer_shift_id
  belongs_to :attendance_type

  after_destroy { |record| VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available }
  after_save { |record| VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available }

  named_scope :is_after_today, lambda {||
    { :conditions => ['(SELECT date FROM volunteer_events WHERE id = (SELECT volunteer_event_id FROM volunteer_shifts WHERE id = assignments.volunteer_shift_id)) > ?', Date.today] }
  }

  named_scope :not_yet_attended, :conditions => ['attendance_type_id IS NULL']

  def description
    self.volunteer_shift.volunteer_event.date.strftime("%D") + " " + self.time_range_s + " " + (self.volunteer_shift.volunteer_task_type_id.nil? ? self.volunteer_shift.volunteer_event.description : self.volunteer_shift.volunteer_task_type.description)
  end

  def display_name
    ((!(self.volunteer_shift.description.nil? or self.volunteer_shift.description.blank?)) ? self.volunteer_shift.description + ": " : "") + self.contact_display
  end

  def cancelled?
    (self.attendance_type and self.attendance_type.cancelled)
  end

  def attended?
    (self.attendance_type and !self.attendance_type.cancelled)
  end

  def contact_display
    if contact_id.nil?
      return "(available)"
    else
      return self.contact.display_name
    end
  end

  def time_range_s
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def has_own_notes
    ((!self.notes.nil?) and self.notes.length > 0)
  end

  def has_notes
    (self.contact and (!self.contact.notes.nil?) and self.contact.notes.length > 0) or has_own_notes
  end

  def skedj_style(overlap, last)
    if self.cancelled?
      return 'cancelled'
    end
    if self.contact_id.nil?
      return 'available'
    end
    if overlap and !(last.cancelled? or self.cancelled?) # TODO: FIXME: BUGGY?
      return 'hardconflict'
    end
    if self.end_time > self.volunteer_shift.send(:read_attribute, :end_time) or self.start_time < self.volunteer_shift.send(:read_attribute, :start_time)
      return 'mediumconflict'
    end
    if self.attendance_type_id
      return 'checked_in'
    end
    return 'shift'
  end
end
