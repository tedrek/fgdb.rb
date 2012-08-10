class AddPrivilegesForSalesPricing < ActiveRecord::Migration
  def self.up
    p = Privilege.new
    p.name = "price_systems"
    p.restrict = false
    p.roles = [Role.find_by_name("STORE")]
    p.save!

    p = Privilege.new
    p.name = "manage_pricing"
    p.restrict = true
    p.roles = [Role.find_by_name("STORE_ADMIN")]
    p.save!
  end

  def self.down
  end
end
