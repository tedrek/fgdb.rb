class VolunteerDefaultShift < ActiveRecord::Base
  validates_presence_of :volunteer_task_type_id
  validates_presence_of :roster_id
  validates_presence_of :weekday_id
  validates_presence_of :end_time
  validates_presence_of :start_time
  validates_presence_of :slot_count

  belongs_to :volunteer_task_type
  belongs_to :weekday

  named_scope :effective_at, lambda { |date|
    { :conditions => ['(effective_at IS NULL OR effective_at <= ?) AND (ineffective_at IS NULL OR ineffective_at > ?)', date, date] }
  }
  named_scope :on_weekday, lambda { |wday|
    { :conditions => ['weekday_id = ?', wday] }
  }

  def skedj_style(overlap, last)
    overlap ? 'hardconflict' : 'shift'
  end

  def describe
    slot_count.to_s + " slots from " + time_range_s
  end

  def time_range_s
    (start_time.strftime("%I:%M") + ' - ' + end_time.strftime("%I:%M")).gsub( ':00', '' ).gsub( ' 0', ' ').gsub( ' - ', '-' ).gsub(/^0/, "")
  end

  def VolunteerDefaultShift.generate(start_date, end_date, gconditions = nil)
    if gconditions
      gconditions = gconditions.dup
      gconditions.empty_enabled = "false"
    else
      gconditions = Conditions.new
    end
    (start_date..end_date).each{|x|
      w = Weekday.find(x.wday)
      next if !w.is_open # TODO: holiday check too
      vs_conds = gconditions.dup
      vs_conds.date_enabled = "true"
      vs_conds.date_date_type = 'daily'
      vs_conds.date_date = x.to_s
      VolunteerShift.destroy_all DB.sql(vs_conds.conditions(VolunteerShift))
      ds_conds = gconditions.dup
      ds_conds.effective_at_enabled = "true"
      ds_conds.effective_at = x.to_s
      ds_conds.weekday_enabled = "true"
      ds_conds.weekday_id = w.id
      shifts = VolunteerDefaultShift.find(:all, :conditions => ds_conds.conditions(VolunteerDefaultShift))
      shifts.each{|ds|
        (1..ds.slot_count).each{|num|
          s = VolunteerShift.new()
          s.volunteer_default_shift_id = ds.id
          s.date = x
          s.start_time = ds.start_time
          s.end_time = ds.end_time
          s.volunteer_task_type_id = ds.volunteer_task_type_id
          s.slot_number = num
          s.roster_id = ds.roster_id
          s.save!
        }
      }
    }
  end

end
