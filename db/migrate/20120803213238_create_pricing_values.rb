class CreatePricingValues < ActiveRecord::Migration
  def self.up
    create_table :pricing_values do |t|
      t.integer :pricing_component_id
      t.string :name
      t.string :matcher
      t.integer :minimum
      t.integer :maximum
      t.integer :value_cents
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :pricing_values
  end
end
