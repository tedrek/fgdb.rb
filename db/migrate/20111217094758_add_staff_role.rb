class AddStaffRole < ActiveRecord::Migration
  def self.up
    p = Privilege.new
    p.name = 'staff'
    p.restrict = false
    p.save!
    r = Role.new
    r.name = 'STAFF_HOURS'
    r.privileges = [p]
    r.save!
  end

  def self.down
  end
end
