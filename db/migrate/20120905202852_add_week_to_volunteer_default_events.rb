class AddWeekToVolunteerDefaultEvents < ActiveRecord::Migration
  def self.up
    add_column :volunteer_default_events, :week, :character
  end

  def self.down
  end
end
