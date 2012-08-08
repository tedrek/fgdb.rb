class AddAfterMultiplierFlag < ActiveRecord::Migration
  def self.up
    add_column :pricing_components, :after_multiplier, :boolean, :default => false
  end

  def self.down
  end
end
