class CreateVolunteerDefaultShifts < ActiveRecord::Migration
  def self.up
    create_table :volunteer_default_shifts do |t|
      t.date :effective_at
      t.date :ineffective_at
      t.integer :weekday_id
      t.time :start_time
      t.time :end_time
      t.integer :slot_count
      t.integer :volunteer_task_type_id
      t.integer :roster_id

      t.timestamps
    end
  end

  def self.down
    drop_table :volunteer_default_shifts
  end
end
