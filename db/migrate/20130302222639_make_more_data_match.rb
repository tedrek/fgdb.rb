class MakeMoreDataMatch < ActiveRecord::Migration
  def self.up
    DB.exec("UPDATE warranty_lengths SET system_type = 'Mac' WHERE system_type LIKE 'Mac Desktop';")
    DB.exec("UPDATE warranty_lengths SET system_type = 'Server' WHERE system_type LIKE 'Servers';")
  end

  def self.down
  end
end
