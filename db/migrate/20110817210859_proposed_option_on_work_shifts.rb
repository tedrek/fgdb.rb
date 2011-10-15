class ProposedOptionOnWorkShifts < ActiveRecord::Migration
  def self.up
    add_column :work_shifts, :proposed, :boolean
  end

  def self.down
    remove_column :work_shifts, :proposed
  end
end
