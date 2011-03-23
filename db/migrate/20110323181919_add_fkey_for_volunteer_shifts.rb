class AddFkeyForVolunteerShifts < ActiveRecord::Migration
  def self.up
    add_foreign_key "volunteer_shifts", ["volunteer_event_id"], "volunteer_events", ["id"], :on_delete => :cascade
  end

  def self.down
  end
end
