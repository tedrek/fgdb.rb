class AddFlaggedToPunchEntries < ActiveRecord::Migration
  def self.up
    add_column :punch_entries, :flagged, :boolean, null: false, default: false
  end

  def self.down
    remove_column :punch_entries, :flagged
  end
end
