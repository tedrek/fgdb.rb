class AddAdminPunchEntriesPrivilege < ActiveRecord::Migration
  class Privilege < ActiveRecord::Base
    has_and_belongs_to_many :roles
  end

  class Role < ActiveRecord::Base
    has_and_belongs_to_many :privileges
  end

  def self.up
    p = Privilege.create(name: 'admin_punch_entries', restrict: true)
    r = Role.find_by_name('ADMIN')
    r.privileges << p
    r.save
  end

  def self.down
    p = Privilege.find_by_name('admin_punch_entries')
    p.destroy
  end
end
