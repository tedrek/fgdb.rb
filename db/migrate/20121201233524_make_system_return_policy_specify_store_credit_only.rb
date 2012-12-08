class MakeSystemReturnPolicySpecifyStoreCreditOnly < ActiveRecord::Migration
  def self.up
    rp = ReturnPolicy.find_by_name("system")
    rp.text = "Returns for store credit only. " + rp.text
    rp.save
  end

  def self.down
  end
end
