class AddYetOneMoreGeneric < ActiveRecord::Migration
  def self.up
    g = Generic.new
    g.value = '............'
    g.only_serial = false
    g.usable = true
    g.save!
  end

  def self.down
  end
end
