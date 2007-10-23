class AdjustedFeesForGizmoEvents < ActiveRecord::Migration
  def self.up
    add_column :gizmo_events, :adjusted_fee, :float
  end

  def self.down
    remove_column :gizmo_events, :adjusted_fee
  end
end
