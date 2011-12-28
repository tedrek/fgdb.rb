class ProposedOptionOnShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :proposed, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :shifts, :proposed
  end
end
