class AddBoleansForVolskedjBehaviors < ActiveRecord::Migration
  def self.up
    add_column :volunteer_default_shifts, :not_numbered, :boolean, :default => false, :null => false
    add_column :volunteer_default_shifts, :stuck_to_assignment, :boolean, :default => false, :null => false
    add_column :volunteer_shifts, :not_numbered, :boolean, :default => false, :null => false
    add_column :volunteer_shifts, :stuck_to_assignment, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :volunteer_default_shifts, :not_numbered
    remove_column :volunteer_default_shifts, :stuck_to_assignment
    remove_column :volunteer_shifts, :not_numbered
    remove_column :volunteer_shifts, :stuck_to_assignment
  end
end
