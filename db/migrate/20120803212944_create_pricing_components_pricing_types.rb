class CreatePricingComponentsPricingTypes < ActiveRecord::Migration
  def self.up
    create_table :pricing_components_pricing_types, :id => false do |t|
      t.integer :pricing_component_id
      t.integer :pricing_type_id
    end
  end

  def self.down
    drop_table :pricing_components_pricing_types
  end
end
