class AddSomeUniqueIndexesToRoleSystem < ActiveRecord::Migration
  def self.up
    add_index 'privileges', 'name', :unique => true
    add_index 'roles', 'name', :unique => true
  end

  def self.down
  end
end
