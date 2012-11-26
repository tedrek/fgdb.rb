class AddOnlineSalesBoolean < ActiveRecord::Migration
  def self.up
    add_column :sales, :online, :boolean, :default => false, :null => false
  end

  def self.down
  end
end
