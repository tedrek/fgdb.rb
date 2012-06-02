class CreateDisktestBatchDrives < ActiveRecord::Migration
  def self.up
    create_table :disktest_batch_drives do |t|
      t.string :serial_number, :null => false
      t.string :system_serial_number
      t.timestamp :destroyed_at
      t.integer :user_destroyed_by_id
      t.integer :disktest_run_id
      t.integer :disktest_batch_id, :null => false

      t.timestamps
    end

    add_foreign_key :disktest_batch_drives, :disktest_run_id, :disktest_runs, :id, :on_delete => :restrict
    add_foreign_key :disktest_batch_drives, :disktest_batch_id, :disktest_runs, :id, :on_delete => :cascade
    add_foreign_key :disktest_batch_drives, :user_destroyed_by_id, :users, :id, :on_delete => :restrict
  end

  def self.down
    drop_table :disktest_batch_drives
  end
end
