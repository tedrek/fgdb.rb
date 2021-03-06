class DefaultAssignment < ActiveRecord::Base
  belongs_to :contact
  belongs_to :volunteer_default_shift
  validates_presence_of :set_weekday_id, :if => :volshift_stuck
  delegate :set_weekday_id, :set_weekday_id=, :to => :volunteer_default_shift
  delegate :effective_on, :effective_on=, :to => :volunteer_default_shift
  delegate :ineffective_on, :ineffective_on=, :to => :volunteer_default_shift
  before_validation :set_values_if_stuck
  delegate :set_description, :set_description=, :to => :volunteer_default_shift
  validates_existence_of :contact, :allow_nil => true
  validate(:contact_type_for_roster, :closed_shift, :contact_for_assignment,
           :overlapping_shifts)

  def real_programs
    return [] unless self.volunteer_default_shift && self.volunteer_default_shift.roster
    return [] unless self.volunteer_default_shift.roster.limit_shift_signup_by_program
    return self.volunteer_default_shift.roster.skeds.select{|x| x.category_type == "Program"}.map{|x| x.name}
  end

  def contact_id=(newval)
    self.write_attribute(:contact_id, newval)
    self.contact = Contact.find_by_id(newval.to_i)
  end

  def next_cycle_date
    if self.week.to_s.strip.length == 0
      return ""
    end
    d = Date.today
    d += 1 while d.wday != self.set_weekday_id
    return ((VolunteerShift.week_for_date(d).upcase == self.week.upcase) ? d : (d + 7)).to_s
  end

  def next_cycle_date=(d)
    self.week = d.to_s.strip.length == 0 ? "" : VolunteerShift.week_for_date(Date.parse(d)).upcase
  end

  def set_values_if_stuck
    return unless volshift_stuck
    volunteer_default_shift.set_values_if_stuck(self)
  end

  def volshift_stuck
    self.volunteer_default_shift && self.volunteer_default_shift.stuck_to_assignment
  end

  after_destroy { |record| record.volunteer_default_shift.destroy if record.volunteer_default_shift && record.volunteer_default_shift.stuck_to_assignment}

  after_destroy { |record| if record.volunteer_default_shift && record.volunteer_default_shift.stuck_to_assignment; record.volunteer_default_shift.destroy; else VolunteerDefaultShift.find_by_id(record.volunteer_default_shift_id).fill_in_available(record.slot_number); end}
  after_save { |record| VolunteerDefaultShift.find_by_id(record.volunteer_default_shift_id).fill_in_available(record.slot_number) }
  after_save {|record| if record.volunteer_default_shift && record.volunteer_default_shift.stuck_to_assignment; record.volunteer_default_shift.save; end}

  validates_presence_of :volunteer_default_shift
  validates_associated :volunteer_default_shift

  def not_assigned
    contact_id.nil? and !closed
  end

  scope :assigned, where('contact_id IS NOT NULL')

  scope :for_slot, lambda{|assignment|
    slot = assignment.slot_number
    shift_id = assignment.volunteer_default_shift_id
    shift_id ||= assignment.volunteer_default_shift.id
    week = assignment.week.to_s.strip
    ret = where("contact_id IS NOT NULL")
      .where(:slot_number => slot)
      .where(:volunteer_default_shift_id => shift_id)
    if week.length > 0
      ret = ret.where('(week IS NULL OR week IN ('', ' ', ?))', week)
    end
    ret
  }

  def does_conflict?(other)
    return false if self.week.to_s.strip.length > 0 and other.week.to_s.strip.length > 0 and self.week.downcase != other.week.downcase
    return false if (self.weeks_enabled & other.weeks_enabled).length == 0
    arr = [self, other]
    arr = arr.sort_by(&:start_time)
    a, b = arr
    a.end_time > b.start_time
  end

  def find_overlappers(type)
    self.class.potential_overlappers(self).send(type, self).overlaps_effective(self).select{|x| self.does_conflict?(x)}
  end

  def overlaps_effective(assignment)
    if assignment.ineffective_on.nil? and assignment.effective_on.nil?
      return scoped().where(:volunteer_default_shift_id =>
                            VolunteerDefaultShift.select(:id))
    end

    sq = VolunteerDefaultShift.select(:id)
    if assignment.effective_on.nil?
      sq = sq.where("(effective_on < ? OR effective_on IS NULL)",
                    assignment.ineffective_on)
    elsif assignment.ineffective_on.nil?
      sq = sq.where("(ineffective_on IS NULL OR ineffective_on > ?)",
                    assignment.effective_on)
    elsif !(assignment.ineffective_on.nil? or assignment.effective_on.nil?)
      sq = sq.where("((ineffective_on IS NULL OR ineffective_on > ?) AND " +
                    " (effective_on < ? OR effective_on IS NULL))",
                    assignment.effective_on, assignment.ineffective_on)
    end
    return scoped().where(:volunteer_default_shift_id => sq)
  end

  scope :potential_overlappers, lambda{|assignment|
    tid = assignment.id
    tday = assignment.volunteer_default_shift.volunteer_default_event.weekday_id
    sq = VolunteerDefaultShift.select(:id).joins(:volunteer_default_events)
    sq = sq.where('volunteer_default_event.weekday_id', tday)
    ret = where('(id != ? OR ? IS NULL)', tid, tid)
    ret = ret.where(:volunteer_default_shift_id => sq)
    return ret
  }

  scope :for_contact, lambda{|assignment|
    where(:contact_id => assignment.contact.id)
  }

  def volunteer_default_shift_attributes=(attrs)
    self.volunteer_default_shift.attributes=(attrs) # just pass it up
  end

  attr_accessor :redirect_to
  def slot_type_desc
    (self.volunteer_default_shift.volunteer_task_type_id.nil? ? self.volunteer_default_shift.volunteer_default_event.description : self.volunteer_default_shift.volunteer_task_type.description)
   end

  def description
    self.volunteer_default_shift.volunteer_default_event.weekday.name + " " + self.time_range_s + self.slot_type_desc
  end

  def skedj_style(overlap, last)
    if self.closed
      return 'cancelled'
    end
    if self.contact_id.nil?
      return 'available'
    end
    if overlap and !self.volshift_stuck and self.week.to_s.strip.length == 0 and self.weeks_enabled.length == 5 # FIXME
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

  def weeks_enabled
    [1, 2, 3, 4, 5].select{|n| self.send("week_#{n}_of_month")}
  end

  def time_range_s
    list = weeks_enabled
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "") + (list.length == 5 ? "" : " [weeks: #{list.join(", ")}]") + (self.week.to_s.strip.length > 0 ? " (week " + self.week + ")" : "")
  end

  def display_name
   ((!(self.volunteer_default_shift.description.nil? or self.volunteer_default_shift.description.blank?)) ? self.volunteer_default_shift.description + ": " : "") + self.contact_display + ((self.volunteer_default_shift.effective_on.nil? and self.volunteer_default_shift.ineffective_on.nil?) ? "" : " (#{self.effective_on || "beginning of time"} till #{self.ineffective_on || "end of time"})")
  end

  def contact_display
    if self.closed
      return "(closed)"
    elsif contact_id.nil?
      return "(available)"
    else
      return self.contact.display_name
    end
  end

  private
  def contact_type_for_roster
    return unless (self.contact_id && self.contact_id_changed?)
    return unless (self.volunteer_shift &&
                   self.volunteer_shift.roster &&
                   self.volunteer_shift.roster.contact_type)
    unless (self.contact.contact_types.include?(
              self.volunteer_shift.roster.contact_type))
      ct = self.volunteer_shift.contact_type.description.humanize.downcase
      errors.add(:contact, "does not have the correct type required to " +
                 "sign up for a shift in this roster (#{ct})")
    end
  end

  def closed_shift
    if (self.closed && !self.contact_id.nil?)
      errors.add("contact_id", "cannot be assigned to a closed shift")
    end
  end

  def contact_for_assignment
    if (self.volunteer_shift &&
        self.volunteer_shift.stuck_to_assignment &&
        self.contact_id.nil?)
      errors.add(:contact_id, "is empty for an assignment-based shift")
    end
  end

  def overlapping_shifts
    unless self.contact.nil? and !self.contact.is_organization
      overlappers = self.find_overlappers(:for_contact)
      if overlappers.length > 0
        errors.add(:contact, 'is not an organization and is already scheduled'\
                   'during that time (' + overlappers.map do |x|
                     'during ' + x.time_range_s + " in " + x.slot_type_desc
                   end.join(',') + ')')
      end
    end
    if self.volunteer_shift && !self.volunteer_shift.not_numbered
      overlappers = self.find_overlappers(:for_slot)
      if overlappers.length > 0
        errors.add(:volunteer_shift, 'is already asigned during that time (' +
                   overlappers.map do |x|
                     'during ' + x.time_range_s + ' to ' + x.contact_display
                   end.join(', ') + ')')
      end
    end
  end
end
