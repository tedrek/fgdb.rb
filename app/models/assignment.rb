class Assignment < ActiveRecord::Base
  belongs_to :volunteer_shift
  has_one :volunteer_task_type, :through => :volunteer_shift, :source => :volunteer_task_type
  belongs_to :contact
  validates_presence_of :volunteer_shift_id
  belongs_to :attendance_type

  after_destroy { |record| VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available }
  after_save { |record| VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available }

  def contact_display
    display_name
  end

  def cancelled?
    (self.attendance_type and self.attendance_type.cancelled)
  end

  def display_name
    if contact_id.nil?
      return "(available)"
    else
      return self.contact.display_name
    end
  end

  def time_range_s
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
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
    if self.end_time > self.volunteer_shift.end_time or self.start_time < self.volunteer_shift.start_time
      return 'mediumconflict'
    end
    if self.attendance_type_id
      return 'checked_in'
    end
    return 'shift'
  end
end
