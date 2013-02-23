class UpdateReceivingEventNotes < ActiveRecord::Migration
  def self.up
    DB.exec("UPDATE volunteer_events SET notes = 'Volunteers working for the first time should work a minimum of 2 hours for training and practice and please do not schedule first timers from 4p to 6p as there is only one staff member for training' WHERE notes LIKE '%%the first time should%%' AND date >= '#{Date.today}' AND description LIKE 'Receiving';")
    DB.exec("UPDATE volunteer_default_events SET notes = 'Volunteers working for the first time should work a minimum of 2 hours for training and practice and please do not schedule first timers from 4p to 6p as there is only one staff member for training' WHERE notes LIKE '%%the first time should%%' AND description LIKE 'Receiving';")
  end

  def self.down
  end
end
