class AddOpenCloseTimes < ActiveRecord::Migration
  def self.up
    add_column :weekdays, :open_time, :time
    add_column :weekdays, :close_time, :time
    Weekday.find(:all).each do |w|
      w.open_time, w.close_time = Time.parse("10:00"), Time.parse("18:00")
      w.save!
    end
    change_column :weekdays, :open_time, :time, :null => false
    change_column :weekdays, :close_time, :time, :null => false
  end

  def self.down
  end
end
