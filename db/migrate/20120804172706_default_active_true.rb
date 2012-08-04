class DefaultActiveTrue < ActiveRecord::Migration
  def self.up
    change_column(:pricing_types, :active, :boolean, :default => true)
    change_column(:pricing_values, :active, :boolean, :default => true)
  end

  def self.down
  end
end
