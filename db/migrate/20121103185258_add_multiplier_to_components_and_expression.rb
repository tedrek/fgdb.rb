class AddMultiplierToComponentsAndExpression < ActiveRecord::Migration
  def self.up
    add_column :pricing_components, :multiplier_cents, :integer, :default => 100, :null => false
    add_column :pricing_expressions, :multiplier_cents, :integer, :default => 100, :null => false
  end

  def self.down
    remove_column :pricing_components, :multiplier_cents
    remove_column :pricing_expressions, :multiplier_cents
  end
end
