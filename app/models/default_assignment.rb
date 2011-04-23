class DefaultAssignment < ActiveRecord::Base
  belongs_to :contact
  belongs_to :volunteer_default_shift

  after_destroy { |record| VolunteerDefaultShift.find_by_id(record.volunteer_default_shift_id).fill_in_available(record.slot_number) }
  after_save { |record| VolunteerDefaultShift.find_by_id(record.volunteer_default_shift_id).fill_in_available(record.slot_number) }

  def slot_type_desc
    (self.volunteer_default_shift.volunteer_task_type_id.nil? ? self.volunteer_default_shift.volunteer_default_event.description : self.volunteer_default_shift.volunteer_task_type.description)
   end

  def description
    self.volunteer_default_shift.volunteer_default_event.weekday.name + " " + self.time_range_s + " " + self.slot_type_desc
  end

  def skedj_style(overlap, last)
    if self.contact_id.nil?
      return 'available'
    end
    if overlap
      return 'hardconflict'
    end
    if self.end_time > self.volunteer_default_shift.send(:read_attribute, :end_time) or self.start_time < self.volunteer_default_shift.send(:read_attribute, :start_time)
      return 'mediumconflict'
    end
    return 'shift'
  end

  def left_method_name
    a = [self.volunteer_default_shift.volunteer_task_type_id.nil? ? self.volunteer_default_shift.volunteer_default_event.description : volunteer_default_shift.volunteer_task_type.description]
    a << self.slot_number
    a.join(", ")
  end

  def time_range_s
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def display_name
    ((!(self.volunteer_default_shift.description.nil? or self.volunteer_default_shift.description.blank?)) ? self.volunteer_default_shift.description + ": " : "") + self.contact_display
  end

  def contact_display
    if contact_id.nil?
      return "(available)"
    else
      return self.contact.display_name
    end
  end
end

