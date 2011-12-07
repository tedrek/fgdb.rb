class AddSizeToDisktestRuns < ActiveRecord::Migration
  def self.up
    add_column :disktest_runs, :megabytes_size, :integer
  end

  def self.down
  end
end
