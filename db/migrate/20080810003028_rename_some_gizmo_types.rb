class RenameSomeGizmoTypes < ActiveRecord::Migration
  def self.up
    GizmoType.connection.execute("UPDATE gizmo_types SET description = 'Sys w/ monitor' WHERE id = 5")
    GizmoType.connection.execute("UPDATE gizmo_types SET description = 'Net Device' WHERE id = 36")
    GizmoType.connection.execute("UPDATE gizmo_types SET description = 'Gift Cert' WHERE id = 45")
  end

  def self.down
  end
end
