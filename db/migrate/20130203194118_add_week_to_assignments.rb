class AddWeekToAssignments < ActiveRecord::Migration
  def self.up
    add_column :default_assignments, :week_1_of_month, :boolean, :default => true, :null => false
    add_column :default_assignments, :week_2_of_month, :boolean, :default => true, :null => false
    add_column :default_assignments, :week_3_of_month, :boolean, :default => true, :null => false
    add_column :default_assignments, :week_4_of_month, :boolean, :default => true, :null => false
    add_column :default_assignments, :week_5_of_month, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :default_assignments, :week_1_of_month
    remove_column :default_assignments, :week_2_of_month
    remove_column :default_assignments, :week_3_of_month
    remove_column :default_assignments, :week_4_of_month
    remove_column :default_assignments, :week_5_of_month
  end
end
