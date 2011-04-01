class StoreCreditPrivileges < ActiveRecord::Migration
  def self.up
    p = Privilege.new(:name => "issue_store_credit")
    p.save!
    r = Role.new(:name => "STORE_CREDIT")
    r.privileges = [p]
    r.save!
    Default["storecredit_expire_after"] = "1.year"
  end

  def self.down
  end
end
