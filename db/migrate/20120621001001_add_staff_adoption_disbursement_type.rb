class AddStaffAdoptionDisbursementType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      d = DisbursementType.new
      d.name = "staff_adoption"
      d.description = "Staff Adoption"
      d.save!
    end
  end

  def self.down
    if Default.is_pdx and d = DisbursementType.find_by_name("staff_adoption")
      d.destroy
    end
  end
end
