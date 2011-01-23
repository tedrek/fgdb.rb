class MiscDisburseType < ActiveRecord::Migration
  def self.up
    dt = DisbursementType.new
    dt.name = "misc"
    dt.description = "Misc."
    dt.save
  end

  def self.down
  end
end
