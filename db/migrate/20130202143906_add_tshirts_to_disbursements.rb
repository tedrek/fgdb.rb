class AddTshirtsToDisbursements < ActiveRecord::Migration
  def self.up
    gt = GizmoType.find_by_name("t_shirt")
    if Default.is_pdx and gt
      gt.gizmo_contexts << GizmoContext.disbursement
      gt.save!
    end
  end

  def self.down
  end
end
