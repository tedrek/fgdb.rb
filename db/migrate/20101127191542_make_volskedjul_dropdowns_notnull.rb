class MakeVolskedjulDropdownsNotnull < ActiveRecord::Migration
  def self.up
    change_column :volunteer_default_shifts, :weekday_id, :integer, :null => false
    change_column :volunteer_default_shifts, :roster_id, :integer, :null => false
#    change_column :volunteer_default_shifts, :volunteer_task_type_id, :integer, :null => false
    change_column :volunteer_shifts, :roster_id, :integer, :null => false
#    change_column :volunteer_shifts, :volunteer_task_type_id, :integer, :null => false
  end

  def self.down
  end
end
