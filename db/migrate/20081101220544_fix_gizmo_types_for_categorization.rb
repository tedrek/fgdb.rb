class FixGizmoTypesForCategorization < ActiveRecord::Migration
  def self.up
    ["UPDATE gizmo_types SET gizmo_category_id = 1 WHERE id IN (39,47);",
     "INSERT INTO gizmo_types (name, description, parent_id, gizmo_category_id, suggested_fee_cents, required_fee_cents) VALUES ('mac_part', 'Mac Part', 13, 4, 0, 0);"].each do |sql|
      GizmoType.connection.execute(sql)
    end
  end

  def self.down
  end
end
