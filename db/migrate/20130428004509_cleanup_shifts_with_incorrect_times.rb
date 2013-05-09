class CleanupShiftsWithIncorrectTimes < ActiveRecord::Migration
  def self.up
    DB.exec("UPDATE volunteer_shifts SET end_time = assignments.end_time, start_time = assignments.start_time FROM assignments WHERE volunteer_shifts.id = assignments.volunteer_shift_id AND volunteer_shifts.stuck_to_assignment = 't' AND (volunteer_shifts.start_time != assignments.start_time OR volunteer_shifts.end_time != assignments.end_time);")
    DB.exec("UPDATE volunteer_default_shifts SET end_time = default_assignments.end_time, start_time = default_assignments.start_time FROM default_assignments WHERE volunteer_default_shifts.id = default_assignments.volunteer_default_shift_id AND volunteer_default_shifts.stuck_to_assignment = 't' AND (volunteer_default_shifts.start_time != default_assignments.start_time OR volunteer_default_shifts.end_time != default_assignments.end_time);")
  end

  def self.down
  end
end
