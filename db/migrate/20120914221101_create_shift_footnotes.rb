class CreateShiftFootnotes < ActiveRecord::Migration
  def self.up
    create_table :shift_footnotes do |t|
      t.integer :weekday_id
      t.integer :schedule_id
      t.text :note

      t.timestamps
    end
    add_foreign_key :shift_footnotes, :weekday_id, :weekdays, :id
    add_foreign_key :shift_footnotes, :schedule_id, :schedules, :id
  end

  def self.down
    drop_table :shift_footnotes
  end
end
