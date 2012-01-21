class RenameWeeklyWorkHours < ActiveRecord::Migration
  def self.up
    rename_column :workers, :weekly_work_hours, :standard_weekly_hours
  end

  def self.down
  end
end
