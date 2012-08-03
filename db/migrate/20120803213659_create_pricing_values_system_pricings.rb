class CreatePricingValuesSystemPricings < ActiveRecord::Migration
  def self.up
    create_table :pricing_values_system_pricings do |t|
      t.integer :pricing_value_id
      t.integer :system_pricing_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pricing_values_system_pricings
  end
end
