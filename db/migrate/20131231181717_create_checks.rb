class CreateChecks < ActiveRecord::Migration
  def self.up
    # A schema which includes this table was committed prior to the
    # migration being committed.  So if the table already exists just carry
    # on without having an error.
    return if ActiveRecord::Base.connection.tables.include?('checks')
    create_table :checks do |t|
      t.references    :run
      t.string        :check_code,    :null => false
      t.boolean       :passed,       :null => false
      t.integer       :sequence_num, :null => false
      t.integer       :status
      t.timestamp     :start_time
      t.timestamp     :end_time
      t.string        :stdout_log
      t.string        :stderr_log
      t.timestamps
    end
  end

  def self.down
    drop_table :checks
  end
end
