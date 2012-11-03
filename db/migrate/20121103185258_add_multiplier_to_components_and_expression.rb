class AddMultiplierToComponentsAndExpression < ActiveRecord::Migration
  def self.up
    add_column :pricing_components, :multiplier, :float, :default => 1.0, :null => false
    add_column :pricing_expressions, :multiplier, :float, :default => 1.0, :null => false
  end

  def self.down
    remove_column :pricing_components, :multiplier
    remove_column :pricing_expressions, :multiplier
  end
end
