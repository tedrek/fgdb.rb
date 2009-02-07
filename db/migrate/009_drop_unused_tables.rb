class DropUnusedTables < ActiveRecord::Migration
  def self.up
    execute 'DROP TABLE meetings CASCADE'
    execute 'DROP TABLE old_work_shifts CASCADE'
    execute 'DROP TABLE standard_shifts CASCADE'
    execute 'DROP TABLE unavailabilities CASCADE'
  end

  def self.down
  end
end
