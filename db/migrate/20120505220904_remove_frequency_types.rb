class RemoveFrequencyTypes < ActiveRecord::Migration
  def self.up
    drop_table :frequency_types
  end

  def self.down
  end
end
