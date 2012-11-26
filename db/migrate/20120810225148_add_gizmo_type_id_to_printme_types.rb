class AddGizmoTypeIdToPrintmeTypes < ActiveRecord::Migration
  def self.up
    add_column :types, :gizmo_type_id, :integer
    add_foreign_key :types, :gizmo_type_id, :gizmo_types, :id, :on_delete => :restrict

    p = PricingType.find_by_name("Mac")
    mac_type = p.gizmo_type
    p.gizmo_type = nil
    mac_laptop_type = GizmoType.find_by_name(mac_type.name.gsub("system", "laptop"))
    p.save!

    t = Type.find_by_name("apple")
    t.gizmo_type = mac_type
    t.save!

    t = Type.find_by_name("apple_laptop")
    t.gizmo_type = mac_laptop_type
    t.save!
  end

  def self.down
  end
end
