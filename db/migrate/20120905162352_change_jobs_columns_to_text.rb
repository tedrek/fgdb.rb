class ChangeJobsColumnsToText < ActiveRecord::Migration
  def self.up
    change_column :jobs, :description, :text
    change_column :jobs, :reason_cannot_log_hours, :text
  end

  def self.down
  end
end
