class RolesForAuthz < ActiveRecord::Migration
  def self.up
    create_table "roles", :force => true do |t|
      t.string   :name,         :limit => 40, :unique => true
      t.column   :created_by,   :bigint
      t.datetime :created_at
      t.column   :updated_by,   :bigint
      t.datetime :updated_at
    end

    create_table "roles_users", :force => true, :id => false do |t|
      t.column   :user_id,      :bigint
      t.column   :role_id,      :bigint
    end

    add_foreign_key("roles_users", [:user_id], "users", [:id], name => "roles_users_users_fk")
    add_foreign_key("roles_users", [:role_id], "roles", [:id], name => "roles_users_roles_fk")
    User.connection.execute("ALTER TABLE roles_users ADD CONSTRAINT roles_users_uk UNIQUE (user_id, role_id)")
  end

  def self.down
    drop_table("roles_users")
    drop_table("roles")
  end
end
