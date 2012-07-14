class AddPrivilegeForPayingInvoices < ActiveRecord::Migration
  def self.up
    r = Role.find_by_name("BEAN_COUNTER")
    r.notes = "Can modify past inventory and control settings, in addition to having unrestricted access to all transaction types and the ability to resolve invoices"
    r.save!

    p = Privilege.new
    p.restrict = true
    p.name = "pay_invoices"
    p.roles << r
    p.save!
  end

  def self.down
    Privilege.find_by_name("pay_invoices").destroy
  end
end
