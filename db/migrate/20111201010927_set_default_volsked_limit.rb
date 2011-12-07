class SetDefaultVolskedLimit < ActiveRecord::Migration
  def self.up
    Default["volskedj_shift_limit"] = 2
  end

  def self.down
  end
end
