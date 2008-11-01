class FixGizmoTypesForCategorization < ActiveRecord::Migration
  def self.up
    ["UPDATE gizmo_types SET gizmo_category_id = 1 WHERE id IN (39,47);",
     "INSERT INTO gizmo_types (name, description, parent_id, gizmo_category_id) VALUES ('mac_part', 'Mac Part', 13, 4);",
     "UPDATE gizmo_types SET suggested_fee_cents = 0 , required_fee_cents = 0, name = 'mac_part' WHERE id = 52;"].each do |sql|
      GizmoType.connection.execute(sql)
    end
  end

  def self.down
  end
end
