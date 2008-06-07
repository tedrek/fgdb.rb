class AddConstraintGcgt < ActiveRecord::Migration
  def self.up
    User.connection.execute("ALTER TABLE gizmo_contexts_gizmo_typeattrs ADD CONSTRAINT gizmo_contexts_gizmo_typeattrs_uk UNIQUE (gizmo_context_id, gizmo_typeattr_id)")
  end

  def self.down
    User.connection.execute("DROP INDEX gizmo_contexts_gizmo_typeattrs_uk")
  end
end
