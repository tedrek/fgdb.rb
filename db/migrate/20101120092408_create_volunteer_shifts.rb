class CreateVolunteerShifts < ActiveRecord::Migration
  def self.up
    create_table :volunteer_shifts do |t|
      t.integer :volunteer_default_shift_id
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :volunteer_task_type_id
      t.integer :slot_number
      t.integer :roster_id

      t.timestamps
    end
  end

  def self.down
    drop_table :volunteer_shifts
  end
end
