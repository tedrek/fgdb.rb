class AddHourToMeetingMinders < ActiveRecord::Migration
  def self.up
    add_column :meeting_minders, :hour, :integer, :default => 7, :null => false
  end

  def self.down
    remove_column :meeting_minders, :hour
  end
end
