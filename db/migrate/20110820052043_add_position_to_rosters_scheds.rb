class AddPositionToRostersScheds < ActiveRecord::Migration
  def self.up
    add_column :rosters_skeds, :position, :integer
    Sked.find(:all).each{|x|
      x.rosters.reset_positions
    }
  end

  def self.down
    remove_column :rosters_skeds, :position
  end
end
