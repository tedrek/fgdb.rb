class AddCanCreateLoginRole < ActiveRecord::Migration
  def self.up
    p = Privilege.new(:name => 'can_create_logins')
    p.save!
    r = Role.new(:name => "CREATE_LOGIN")
    r.privileges = [p]
    r.save!
  end

  def self.down
  end
end
