class AddYetMoreGeneralSerials < ActiveRecord::Migration
  def self.up
    for i in ["= '00000000'", "EeePC-1234567890", "01234567", "..              ."]
      g = Generic.new
      g.value = i
      g.only_serial = true
      g.usable = true
      g.save!
    end
  end

  def self.down
  end
end
