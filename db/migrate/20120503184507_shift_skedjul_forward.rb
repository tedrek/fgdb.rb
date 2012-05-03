class ShiftSkedjulForward < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      Weekday.find(:all).each do |w|
        w.start_time -= 1.hour
        w.end_time -= 1.hour
        w.save!
      end
    end
  end

  def self.down
  end
end
