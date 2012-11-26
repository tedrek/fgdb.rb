class AddForeignKeysToPricingTables < ActiveRecord::Migration
  def self.up
    add_foreign_key :pricing_types, :type_id, :types, :id, :on_delete => :restrict
    add_foreign_key :pricing_values, :pricing_component_id, :pricing_components, :id, :on_delete => :restrict

    add_foreign_key :pricing_components_pricing_types, :pricing_type_id, :pricing_types, :id, :on_delete => :restrict
    add_foreign_key :pricing_components_pricing_types, :pricing_component_id, :pricing_components, :id, :on_delete => :restrict

    add_foreign_key :pricing_values_system_pricings, :pricing_value_id, :pricing_values, :id, :on_delete => :restrict
    add_foreign_key :pricing_values_system_pricings, :system_pricing_id, :system_pricings, :id, :on_delete => :restrict

    add_foreign_key :system_pricings, :system_id, :systems, :id, :on_delete => :restrict
    add_foreign_key :system_pricings, :spec_sheet_id, :spec_sheets, :id, :on_delete => :restrict
    add_foreign_key :system_pricings, :pricing_type_id, :pricing_types, :id, :on_delete => :restrict
  end

  def self.down
  end
end
