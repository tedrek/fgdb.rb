class AddGizmoTypeToPricingTypes < ActiveRecord::Migration
  def self.up
    add_column :pricing_types, :gizmo_type_id, :integer
    add_foreign_key :pricing_types, :gizmo_type_id, :gizmo_types, :id
  end

  def self.down
  end
end
