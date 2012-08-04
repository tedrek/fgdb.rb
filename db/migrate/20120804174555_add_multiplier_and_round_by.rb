class AddMultiplierAndRoundBy < ActiveRecord::Migration
  def self.up
    add_column :pricing_types, :multiplier_cents, :integer, :default => 1.00
    add_column :pricing_types, :round_by, :integer, :default => 1
    add_column :system_pricings, :calculated_price_cents, :integer
  end

  def self.down
  end
end
