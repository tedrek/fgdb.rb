class LinkTransactionsToSystem < ActiveRecord::Migration
  def self.up
    add_column "gizmo_events", "system_id", :integer
    add_foreign_key "gizmo_events", "system_id", "systemss", "id", :on_delete => :restrict
  end

  def self.down
    remove_column "gizmo_events", "system_id"
  end
end
