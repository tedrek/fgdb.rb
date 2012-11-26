class AddNotApplicableGeneric < ActiveRecord::Migration
  def self.up
    g = Generic.new
    g.value = "Not Applicable"
    g.usable = true
    g.only_serial = true
    g.save!
  end

  def self.down
  end
end
