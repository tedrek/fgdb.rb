class VolunteerDefaultShift < ActiveRecord::Base
#  validates_presence_of :volunteer_task_type_id
  validates_presence_of :roster_id
  validates_presence_of :end_time
  validates_presence_of :start_time
  validates_presence_of :slot_count

  belongs_to :volunteer_task_type
  belongs_to :volunteer_default_event
  belongs_to :program

  has_one :default_assignment

  after_save :save_default_assign

  def save_default_assign
    if self.default_assignment
      self.default_assignment.save!
    else
      old = DefaultAssignment.find_by_volunteer_default_shift_id(self.id)
      old.destroy if old
    end
  end

  named_scope :effective_at, lambda { |date|
    { :conditions => ['(effective_at IS NULL OR effective_at <= ?) AND (ineffective_at IS NULL OR ineffective_at > ?)', date, date] }
  }
  named_scope :on_weekday, lambda { |wday|
    { :conditions => ['weekday_id = ?', wday] }
  }

  def contact_id
    da = self.default_assignment
    return da.nil? ? nil : da.contact_id
  end

  def contact_id=(val)
    val = nil if val and val.length == 0
    da = self.default_assignment
    if val.nil?
      self.default_assignment = nil
    else
      da = self.default_assignment = DefaultAssignment.new(:volunteer_default_shift_id => self.id) if da.nil?
      da.contact_id = val
    end
  end

  def skedj_style(overlap, last)
    overlap ? 'hardconflict' : 'shift'
  end

  def describe
    slot_count.to_s + " slots from " + time_range_s
  end

  def time_range_s
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def time_shift(val)
    self.start_time += val
    self.end_time += val
  end

  def VolunteerDefaultShift.generate(start_date, end_date, gconditions = nil)
    if gconditions
      gconditions = gconditions.dup
      gconditions.empty_enabled = "false"
    else
      gconditions = Conditions.new
    end
    (start_date..end_date).each{|x|
      next if Holiday.is_holiday?(x)
      w = Weekday.find(x.wday)
      next if !w.is_open
      vs_conds = gconditions.dup
      vs_conds.date_enabled = "true"
      vs_conds.date_date_type = 'daily'
      vs_conds.date_date = x
      VolunteerShift.find(:all, :conditions => vs_conds.conditions(VolunteerShift), :include => [:volunteer_event]).each{|y| y.destroy} # TODO: destroy_all with the :include somehow..
      ds_conds = gconditions.dup
      ds_conds.effective_at_enabled = "true"
      ds_conds.effective_at = x
      ds_conds.weekday_enabled = "true"
      ds_conds.weekday_id = w.id
      puts ds_conds.conditions(VolunteerDefaultShift).inspect
      shifts = VolunteerDefaultShift.find(:all, :conditions => ds_conds.conditions(VolunteerDefaultShift), :include => [:volunteer_default_event])
      shifts.each{|ds|
        myl = []
        ve = VolunteerEvent.find(:all, :conditions => ["volunteer_default_event_id = ? AND date = ?", ds.volunteer_default_event_id, x]).first
        if !ve
          ve = VolunteerEvent.new
          ve.volunteer_default_event_id = ds.volunteer_default_event_id
          ve.date = x
        else
          myl = ve.volunteer_shifts.select{|y| ds.volunteer_task_type_id == y.volunteer_task_type_id}.map{|y| y.slot_number}
        end
        ve.description = ds.volunteer_default_event.description
        ve.notes = ds.volunteer_default_event.notes
        ve.save!
        slot_number = 1
        first = true
        (1..ds.slot_count).each{|num|
          while myl.include?(slot_number)
            slot_number += 1
          end
          s = VolunteerShift.new()
          s.volunteer_default_shift_id = ds.id
          s.volunteer_event_id = ve.id
          s.program_id = ds.program_id
          s.description = ds.description
          s.send(:write_attribute, :start_time, ds.start_time)
          s.send(:write_attribute, :end_time, ds.end_time)
          s.volunteer_task_type_id = ds.volunteer_task_type_id
          s.slot_number = slot_number
          s.roster_id = ds.roster_id
          s.save!
          if first and ds.contact_id
            a = s.assignments.first
            a.contact_id = ds.contact_id
            a.save!
          end
          myl << slot_number
          first = false
        }
      }
    }
  end

  def my_start_time(format = "%H:%M")
    read_attribute(:start_time).strftime(format)
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
end
