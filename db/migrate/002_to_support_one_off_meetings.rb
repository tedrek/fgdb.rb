class ToSupportOneOffMeetings < ActiveRecord::Migration
  def self.up
    add_column "standard_shifts", "shift_date", :date
  end

  def self.down
    remove_column "standard_shifts", "shift_date"
  end
end
