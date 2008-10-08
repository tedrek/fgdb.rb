class FixUpRoles < ActiveRecord::Migration
  def self.up
    Role.connection.execute("UPDATE roles SET name=replace(name, '', '')")
  end

  def self.down
  end
end
