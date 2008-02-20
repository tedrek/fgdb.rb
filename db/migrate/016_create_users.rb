class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
    end

    add_column "contacts", :user_id, :bigint
    add_foreign_key "contacts", [:user_id], "users", [:id], :name => "contacts_users_fk"

    user = User.new({:login => "admin"})
    user.email = "admin@example.com"
    user.password_confirmation = "secret"
    user.password = "secret"
    user.save()
  end

  def self.down
    remove_foreign_key "contacts", "contacts_users_fk"
    remove_column "contacts", :user_id
    drop_table "users"
  end
end
