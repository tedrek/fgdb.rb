class ClosedBooleanToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :closed, :boolean, :default => false, :null => false
  end

  def self.down
  end
end
