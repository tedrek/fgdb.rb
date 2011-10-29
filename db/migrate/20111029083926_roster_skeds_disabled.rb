class RosterSkedsDisabled < ActiveRecord::Migration
  def self.up
    add_column :rosters, :enabled, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :rosters, :enabled
  end
end
