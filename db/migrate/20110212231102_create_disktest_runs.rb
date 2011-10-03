class CreateDisktestRuns < ActiveRecord::Migration
  def self.up
    create_table :disktest_runs do |t|
      t.string :vendor
      t.string :model
      t.string :serial_number
      t.datetime :completed_at
      t.string :result

      t.timestamps
    end
  end

  def self.down
    drop_table :disktest_runs
  end
end
