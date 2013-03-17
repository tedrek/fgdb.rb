class AddLockVersionToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :lock_version, :integer, :default => 0, :null => false
    add_column :default_assignments, :lock_version, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :assignments, :lock_version
    remove_column :default_assignments, :lock_version
  end
end
