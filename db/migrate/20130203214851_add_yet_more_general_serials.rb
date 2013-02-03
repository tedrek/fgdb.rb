class AddYetMoreGeneralSerials < ActiveRecord::Migration
  def self.up
    for i in ["= '00000000'", "EeePC-1234567890", "01234567", "..              .", "Unknow", "0123456789AB", "SystemSerialNumb", "12", "12 4", "SSN12345678901234567", "Not Available", "Bank0/1", "FIELD", "X312345678", "Sat May 05 22:08:37 2007"]
      g = Generic.find_or_create_by_value(i)
      g.only_serial = true
      g.usable = true
      g.save!
    end
  end

  def self.down
  end
end
