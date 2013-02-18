class AddGenericSerialNumbers < ActiveRecord::Migration
  def self.up
    g = Generic.new
    g.value = "Base Board Serial Number"
    g.only_serial = true
    g.usable = true
    g.save!
  end

  def self.down
  end
end
