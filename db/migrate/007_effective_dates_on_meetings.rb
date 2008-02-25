class EffectiveDatesOnMeetings < ActiveRecord::Migration
  def self.up
    execute 'UPDATE shifts SET effective_date = \'1901-12-22\' WHERE effective_date IS NULL'
    execute 'UPDATE shifts SET ineffective_date = \'2100-12-31\' WHERE ineffective_date IS NULL'
  end

  def self.down
  end
end
