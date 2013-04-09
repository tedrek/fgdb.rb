class RenameCollectiveRoleToManagement < ActiveRecord::Migration
  def self.up
    r = Role.find_by_name("COLLECTIVE")
    r.name = "MANAGEMENT"
    r.save!
  end

  def self.down
  end
end
