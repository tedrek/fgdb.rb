class CreatePrivilegesRoles < ActiveRecord::Migration
  def self.up
    create_table :privileges_roles do |t|
      t.integer :privilege_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :privileges_roles
  end
end
