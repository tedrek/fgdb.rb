class AddLogTextFieldToDisktestRuns < ActiveRecord::Migration
  def self.up
    add_column :disktest_runs, :log, :text
  end

  def self.down
  end
end
