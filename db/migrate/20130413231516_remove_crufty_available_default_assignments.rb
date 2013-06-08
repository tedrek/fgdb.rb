class RemoveCruftyAvailableDefaultAssignments < ActiveRecord::Migration
  def self.up
    DB.exec("DELETE FROM default_assignments USING volunteer_default_shifts WHERE volunteer_default_shift_id = volunteer_default_shifts.id AND default_assignments.slot_number > volunteer_default_shifts.slot_count;")
  end

  def self.down
  end
end
