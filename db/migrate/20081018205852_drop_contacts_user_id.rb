class DropContactsUserId < ActiveRecord::Migration
  def self.up
    remove_column :contacts, "user_id"
  end

  def self.down
    add_column :contacts, "user_id", :integer
    add_foreign_key :contacts, ["user_id"], :users, ["id"]
  end
end
