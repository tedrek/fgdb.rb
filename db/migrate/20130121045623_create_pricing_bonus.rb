class CreatePricingBonus < ActiveRecord::Migration
  def self.up
    create_table :pricing_bonus do |t|
      t.integer :system_pricing_id
      t.integer :amount_cents
      t.string :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :pricing_bonus
  end
end
