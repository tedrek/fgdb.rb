class CreatePricingTypes < ActiveRecord::Migration
  def self.up
    create_table :pricing_types do |t|
      t.string :name
      t.integer :type_id
      t.string :pull_from
      t.string :matcher
      t.integer :base_value_cents
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :pricing_types
  end
end
