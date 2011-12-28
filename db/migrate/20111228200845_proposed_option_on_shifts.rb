class ProposedOptionOnShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :proposed, :default => false, :null => false
  end

  def self.down
  end
end
