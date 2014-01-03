class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.references  :drive
      t.string      :device_name
      t.timestamp   :start_time
      t.timestamp   :end_time
      t.string      :result
      t.timestamps
    end
  end

  def self.down
    drop_table :runs
  end
end
