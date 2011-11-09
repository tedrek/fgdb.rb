class Assignment < ActiveRecord::Base
  attr_accessor :redirect_to
  belongs_to :volunteer_shift
  has_one :volunteer_task_type, :through => :volunteer_shift, :source => :volunteer_task_type
  belongs_to :contact
  validates_presence_of :volunteer_shift
  validates_associated :volunteer_shift
  belongs_to :attendance_type
  belongs_to :call_status_type
  validates_presence_of :set_date, :if => :volshift_stuck

  delegate :set_date, :set_date=, :to => :volunteer_shift

  before_validation :set_values_if_stuck
  def set_values_if_stuck
    return unless volshift_stuck
    volunteer_shift.set_values_if_stuck
  end

  after_destroy { |record| if record.volunteer_shift && record.volunteer_shift.stuck_to_assignment; record.volunteer_shift.destroy; else VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available; end}
  after_save {|record| if record.volunteer_shift && record.volunteer_shift.stuck_to_assignment; record.volunteer_shift.save; end}
  after_save { |record| VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available }

  def volunteer_shift_attributes=(attrs)
    self.volunteer_shift.attributes=(attrs) # just pass it up
  end

  def volshift_stuck
    self.volunteer_shift && self.volunteer_shift.stuck_to_assignment
  end

  def validate
    if self.volunteer_shift && self.volunteer_shift.stuck_to_assignment
      errors.add("contact_id", "is empty for a assignment-based shift") if self.contact_id.nil?
    end
    unless self.cancelled?
      errors.add("contact_id", "is not an organization and is already scheduled during that time") if self.contact and !(self.contact.is_organization) and (self.find_overlappers(:for_contact).length > 0)
      errors.add("volunteer_shift_id", "is already assigned during that time") if self.volunteer_shift && !self.volunteer_shift.not_numbered && self.find_overlappers(:for_slot).length > 0
     end
  end

  def date
    volunteer_shift.date
  end

  named_scope :is_after_today, lambda {||
    { :conditions => ['(SELECT date FROM volunteer_events WHERE id = (SELECT volunteer_event_id FROM volunteer_shifts WHERE id = assignments.volunteer_shift_id)) > ?', Date.today] }
  }

  named_scope :on_or_after_today, lambda {||
    { :conditions => ['(SELECT date FROM volunteer_events WHERE id = (SELECT volunteer_event_id FROM volunteer_shifts WHERE id = assignments.volunteer_shift_id)) >= ?', Date.today] }
  }

  named_scope :not_yet_attended, :conditions => ['attendance_type_id IS NULL']

  named_scope :potential_overlappers, lambda{|assignment|
    tid = assignment.id
    tdate = assignment.volunteer_shift.volunteer_event.date
    { :conditions => ['(id != ? OR ? IS NULL) AND (attendance_type_id IS NULL OR attendance_type_id NOT IN (SELECT id FROM attendance_types WHERE cancelled = \'t\')) AND volunteer_shift_id IN (SELECT volunteer_shifts.id FROM volunteer_shifts JOIN volunteer_events ON volunteer_events.id = volunteer_shifts.volunteer_event_id WHERE volunteer_events.date = ?)', tid, tid, tdate] }
  }

  named_scope :not_cancelled, :conditions => ['(attendance_type_id IS NULL OR attendance_type_id NOT IN (SELECT id FROM attendance_types WHERE cancelled = \'t\'))']

  named_scope :for_contact, lambda{|assignment|
    tcid = assignment.contact.id
    { :conditions => ['contact_id = ?', tcid] }
  }

  named_scope :for_slot, lambda{|assignment|
    has_task_type = ! assignment.volunteer_shift.volunteer_task_type_id.nil?
    ret = nil
    if has_task_type
      tslot = assignment.volunteer_shift.slot_number
      ttid = assignment.volunteer_shift.volunteer_task_type_id
      ret = {:conditions => ['contact_id IS NOT NULL AND volunteer_shift_id IN (SELECT id FROM volunteer_shifts WHERE slot_number = ? AND volunteer_task_type_id = ?)', tslot, ttid]}
    else
      tslot = assignment.volunteer_shift.slot_number
      teid = assignment.volunteer_shift.volunteer_event_id
      ret = {:conditions => ['contact_id IS NOT NULL AND volunteer_shift_id IN (SELECT id FROM volunteer_shifts WHERE slot_number = ? AND volunteer_event_id = ? AND volunteer_task_type_id IS NULL)', tslot, teid]}
    end
    ret
  }

  def my_call_status
    self.call_status_type_id ? self.call_status_type.name : "not called yet"
  end

  def display_call_status
    " - " + self.my_call_status + " - "
  end

  def display_phone_numbers
    self.contact_id ? self.contact.display_phone_numbers : ""
  end

  def does_conflict?(other)
    arr = [self, other]
    arr = arr.sort_by(&:start_time)
    a, b = arr
    a.end_time > b.start_time
  end

  def find_overlappers(type)
    Assignment.potential_overlappers(self).send(type, self).select{|x| self.does_conflict?(x)}
  end

  def description
    self.volunteer_shift.volunteer_event.date.strftime("%D") + " " + self.time_range_s + " " + self.slot_type_desc
  end

  def slot_type_desc
    (self.volunteer_shift.volunteer_task_type_id.nil? ? self.volunteer_shift.volunteer_event.description : self.volunteer_shift.volunteer_task_type.description)
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
      if self.volunteer_shift.volunteer_task_type_id == VolunteerTaskType.evaluation_type.id
        return self.contact.display_name + "(#{self.contact.syseval_count})"
      else
        return self.contact.display_name
      end
    end
  end

  def contact_id_and_today
    (!!contact_id) && (self.volunteer_shift.volunteer_event.date <= Date.today)
  end

  def time_range_s
    return "" unless start_time and end_time
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
    if overlap and !(last.cancelled? or self.cancelled?) and !self.volshift_stuck# TODO: FIXME: BUGGY? need a order by cancelled too then probably..
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
