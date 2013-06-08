class CleanupInvalidVolunteerDefaultShifts < ActiveRecord::Migration
  def self.up
    DB.exec("DELETE FROM default_assignments where volunteer_default_shift_id IS NULL;")
  end

  def self.down
  end
end
