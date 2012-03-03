class AddInventoryLockAndPrivilege < ActiveRecord::Migration
  def self.up
    p = Privilege.new(:name => "modify_inventory", :restrict => true)
    r = Role.find_by_name("BEAN_COUNTER")
    p.roles << r
    p.save!
  end

  def self.down
  end
end
