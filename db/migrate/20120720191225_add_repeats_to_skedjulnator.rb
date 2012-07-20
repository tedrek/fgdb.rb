class AddRepeatsToSkedjulnator < ActiveRecord::Migration
  def self.up
    add_column :shifts, :repeats_every_months, :integer, :null => false, :default => 1
    add_column :shifts, :repeats_on_months, :integer, :null => false, :default => 0
  end

  def self.down
  end
end
