class CreatePricingAdjustments < ActiveRecord::Migration
  def self.up
    create_table :pricing_adjustments do |t|
      t.integer :system_pricing_id
      t.string :note
      t.integer :amount_cents

      t.timestamps
    end
  end

  def self.down
    drop_table :pricing_adjustments
  end
end
