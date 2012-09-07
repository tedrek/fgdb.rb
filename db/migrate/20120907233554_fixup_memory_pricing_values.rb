class FixupMemoryPricingValues < ActiveRecord::Migration
  def self.up
    PricingComponent.find_by_name("RAM Size").pricing_values.each{|x| x.name = x.name.sub(/ /, ""); x.save}
  end

  def self.down
  end
end
