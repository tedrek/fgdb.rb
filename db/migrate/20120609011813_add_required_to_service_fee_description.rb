class AddRequiredToServiceFeeDescription < ActiveRecord::Migration
  def self.up
    if Default.is_pdx and gizmo_type = GizmoType.find_by_name("service_fee")
      gizmo_type.description = "Required " + gizmo_type.description
      gizmo_type.save!
    else
      puts "Skipping migration."
    end
  end

  def self.down
  end
end
