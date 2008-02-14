class IndexUserId < ActiveRecord::Migration
  def self.up
    add_index :contacts, :user_id
  end

  def self.down
    remove_index :contacts, :user_id
  end
end
