class VolskedjPrivileges < ActiveRecord::Migration
  def self.up
    p = Privilege.new(:name => "schedule_volunteers")
    p.roles = [Role.find_by_name("VOLUNTEER_MANAGER")]
    p.save!
    p = Privilege.new(:name => "admin_skedjul")
    p.roles = [Role.find_by_name("ADMIN")]
    p.save!
  end

  def self.down
  end
end
