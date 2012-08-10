class AddMultiplierAndRoundBy < ActiveRecord::Migration
  def self.up
    add_column :pricing_types, :multiplier_cents, :integer, :default => 100
    add_column :pricing_types, :round_by_cents, :integer, :default => 100
    add_column :system_pricings, :calculated_price_cents, :integer
  end

  def self.down
    remove_column :pricing_types, :multiplier_cents
    remove_column :pricing_types, :round_by
    remove_column :system_pricings, :calculated_price_cents
  end
end
