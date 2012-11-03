class AddMultiplierToComponentsAndExpression < ActiveRecord::Migration
  def self.up
    add_column :pricing_components, :multiplier, :float
    add_column :pricing_expressions, :multiplier, :float
  end

  def self.down
  end
end
