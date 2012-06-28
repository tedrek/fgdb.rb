class AddOffsiteBoolToStaffSchedulingAndHours < ActiveRecord::Migration
  def self.up
    add_column :jobs, :offsite, :boolean, :null => false, :default => false
    add_column :work_shifts, :offsite, :boolean, :null => false, :default => false
    add_column :shifts, :offsite, :boolean, :null => false, :default => false
    add_column :worked_shifts, :offsite, :boolean
  end

  def self.down
  end
end
