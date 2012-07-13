class AllowFrontdeskToEnterReturns < ActiveRecord::Migration
  def self.up
    r = Role.find_by_name('FRONT_DESK')
    r.privileges << Privilege.find_by_name('create_gizmo_returns')
    r.privileges << Privilege.find_by_name('view_gizmo_returns')
    r.notes = "Can create and change disbursement records, but can only create donation, return and recycling records"
    r.save
  end

  def self.down
  end
end
