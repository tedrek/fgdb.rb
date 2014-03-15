class AddBreaksToTimeEntry < ActiveRecord::Migration
  def self.up
    add_column :punch_entries, :breaks, :integer, null: false, default: 0
  end

  def self.down
    remove_column :punch_entries, :breaks
  end
end
