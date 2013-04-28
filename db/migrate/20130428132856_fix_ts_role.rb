class FixTsRole < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      r = Role.find_by_name("TECH_SUPPORT")
      r.privileges = ["techsupport_workorders", "view_sales", "view_disbursements", "view_gizmo_returns", "manage_contacts"].map{|x| Privilege.find_by_name(x)}
      r.notes = "Can create work orders and view sales, returns, disbursements and contacts"
      r.save!
    end
  end

  def self.down
  end
end
