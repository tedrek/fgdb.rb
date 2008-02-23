class UserContactId < ActiveRecord::Migration
  def self.up
    add_column "users", :contact_id, :bigint
    add_foreign_key "users", [:contact_id], "contacts", [:id], :name => "users_contacts_fk"
  end

  def self.down
    remove_foreign_key "users", "users_contacts_fk"
    remove_column "users", :contact_id
  end
end
