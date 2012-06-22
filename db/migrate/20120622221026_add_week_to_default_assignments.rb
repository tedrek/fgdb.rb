class AddWeekToDefaultAssignments < ActiveRecord::Migration
  def self.up
    add_column :default_assignments, :week, :character
  end

  def self.down
  end
end
