class AddSharedFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :shared, :boolean, :default => false, :null => false
    add_column :privileges, :type, :string
  end

  def self.down
    remove_column :users, :shared
    remove_column :privileges, :type
  end
end
