class AddRecyclingAdmin < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
     Role.new(:name => 'RECYCLING_ADMIN', :privileges => Privilege.find_all_by_name('change_recyclings')).save
    end
  end

  def self.down
  end
end
