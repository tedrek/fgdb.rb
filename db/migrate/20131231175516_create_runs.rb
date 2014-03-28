class CreateRuns < ActiveRecord::Migration
  def self.up
    # A schema which includes this table was committed prior to the
    # migration being committed.  So if the table already exists just carry
    # on without having an error.
    return if ActiveRecord::Base.connection.tables.include?('runs')
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
