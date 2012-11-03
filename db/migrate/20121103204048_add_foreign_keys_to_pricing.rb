class AddForeignKeysToPricing < ActiveRecord::Migration
  def self.up
    add_foreign_key :pricing_expressions, :pricing_type_id, :pricing_types, :id, :on_delete => :cascade
    add_foreign_key :pricing_components_pricing_expressions, :pricing_component_id, :pricing_components, :id, :on_delete => :cascade
    add_foreign_key :pricing_components_pricing_expressions, :pricing_expression_id, :pricing_expressions, :id, :on_delete => :cascade
    add_foreign_key :pricing_adjustments, :system_pricing_id, :system_pricings, :id, :on_delete => :cascade
  end

  def self.down
  end
end
