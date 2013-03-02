class MakeDataMatch < ActiveRecord::Migration
  def self.up
    DB.exec("UPDATE warranty_lengths SET box_source = 'Hardware Grant' WHERE box_source LIKE 'HW Grants';")
  end

  def self.down
  end
end
