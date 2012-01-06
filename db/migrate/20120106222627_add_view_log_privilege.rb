class AddViewLogPrivilege < ActiveRecord::Migration
  def self.up
    p = Privilege.new(:name => "view_logs")
    r = Role.find_by_name("ADMIN")
    p.roles << r
    p.save!
  end

  def self.down
  end
end
