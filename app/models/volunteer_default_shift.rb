class VolunteerDefaultShift < ActiveRecord::Base
  named_scope :effective_at, lambda { |date|
    { :conditions => ['(effective_at IS NULL OR effective_at <= ?) AND (ineffective_at IS NULL OR ineffective_at > ?)', date, date] }
  }
  named_scope :on_weekday, lambda { |wday|
    { :conditions => ['weekday_id = ?', wday] }
  }

  def VolunteerDefaultShift.generate(start_date, end_date)
    (start_date..end_date).each{|x|
      w = Weekday.find(x.wday)
      next if !w.is_open # TODO: holiday check too
#      VolunteerShift.destroy_all "date = '#{x}'"
      VolunteerShift.destroy_all # REMOVEME, with above
      DB.run("DELETE FROM assignments") # REMOVEME, with fkeys
      shifts = VolunteerDefaultShift.effective_at(x).on_weekday(w)
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
