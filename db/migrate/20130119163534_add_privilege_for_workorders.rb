class AddPrivilegeForWorkorders < ActiveRecord::Migration
  def self.up
    p = Privilege.new
    p.name = 'techsupport_workorders'
    p.roles = [Role.find_by_name('TECH_SUPPORT'), Role.find_by_name('FRONT_DESK')]
    p.restrict = false
    p.save
  end

  def self.down
  end
end
