class RemoveUnusedScheduleTables < ActiveRecord::Migration
  def self.up
    drop_table :unavailabilities
    drop_table :meetings
  end

  def self.down
  end
end
