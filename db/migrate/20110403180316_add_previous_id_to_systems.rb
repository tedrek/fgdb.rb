class AddPreviousIdToSystems < ActiveRecord::Migration
  def self.up
    add_column :systems, :previous_id, :integer
    add_foreign_key "systems", ["previous_id"], "systems", ["id"]
  end

  def self.down
  end
end
