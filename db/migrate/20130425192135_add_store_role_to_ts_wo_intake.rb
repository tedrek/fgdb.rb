class AddStoreRoleToTsWoIntake < ActiveRecord::Migration
  def self.up
    p = Privilege.find_by_name('techsupport_workorders')
    r = Role.find_by_name('STORE')
    r.privileges << p
    r.save!
  end

  def self.down
  end
end
