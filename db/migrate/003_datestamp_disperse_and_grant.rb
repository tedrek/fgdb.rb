class DatestampDisperseAndGrant < ActiveRecord::Migration
  def self.up
    add_column "dispersements", "dispersed_at", :datetime, :null => false
    add_column "recyclings", "recycled_at", :datetime, :null => false
  end

  def self.down
    remove_column "dispersements", "dispersed_at"
    remove_column "recyclings", "recycled_at"
  end
end
