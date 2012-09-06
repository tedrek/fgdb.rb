class AddWeekToShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :week, :character
  end

  def self.down
  end
end
