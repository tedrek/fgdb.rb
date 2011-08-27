class DefaultAssignment < ActiveRecord::Base
  belongs_to :contact
  belongs_to :volunteer_default_shift

  after_destroy { |record| record.volunteer_default_shift.destroy if record.volunteer_default_shift && record.volunteer_default_shift.stuck_to_assignment}
  before_save :set_values_if_stuck
  def set_values_if_stuck
    return unless self.volunteer_default_shift && self.volunteer_default_shift.stuck_to_assignment
    self.volunteer_default_shift.start_time = self.start_time
    self.volunteer_default_shift.end_time = self.end_time
    self.volunteer_default_shift.save
  end

  after_destroy { |record| if record.volunteer_default_shift && record.volunteer_default_shift.stuck_to_assignment; record.volunteer_default_shift.destroy; else VolunteerDefaultShift.find_by_id(record.volunteer_default_shift_id).fill_in_available(record.slot_number); end}
  after_save { |record| VolunteerDefaultShift.find_by_id(record.volunteer_default_shift_id).fill_in_available(record.slot_number) }
  after_save {|record| if record.volunteer_default_shift && record.volunteer_default_shift.stuck_to_assignment; record.volunteer_default_shift.save; end}

  validates_presence_of :volunteer_default_shift
  validates_associated :volunteer_default_shift

  def validate
    if self.volunteer_default_shift && self.volunteer_default_shift.stuck_to_assignment
      errors.add("contact_id", "is empty for a assignment-based shift") if self.contact_id.nil?
    end
  end

  def volunteer_default_shift_attributes=(attrs)
    self.volunteer_default_shift.attributes=(attrs) # just pass it up
  end

  attr_accessor :redirect_to
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
    a << self.volunteer_default_shift.description
    a << self.slot_number
    a.select{|x| x.to_s.length > 0}.join(", ")
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

