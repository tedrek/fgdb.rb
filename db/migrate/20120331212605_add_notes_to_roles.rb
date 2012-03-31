class AddNotesToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :notes, :string
  end

  def self.down
  end
end
