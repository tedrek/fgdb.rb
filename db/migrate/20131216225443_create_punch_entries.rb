class CreatePunchEntries < ActiveRecord::Migration
  def self.up
    create_table :punch_entries do |t|
      t.integer :contact_id, null: false
      t.integer :volunteer_task_id
      t.timestamp :in_time, null: false
      t.timestamp :out_time
    end
  end

  def self.down
    drop_table :punch_entries
  end
end
