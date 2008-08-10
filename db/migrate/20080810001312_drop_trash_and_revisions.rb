class DropTrashAndRevisions < ActiveRecord::Migration
  def self.up
    drop_table "trash_records"
    drop_table "revision_records"
  end

  def self.down
  end
end
