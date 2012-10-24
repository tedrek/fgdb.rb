class AddBarebonesSystemType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gt = GizmoType.new
      gt.description = "Barebones System As-Is"
      gt.name = "barebones"
      gt.gizmo_contexts = [GizmoContext.sale]
      gt.covered = false
      gt.suggested_fee_cents = 0
      gt.required_fee_cents = 0
      gt.parent_name = "gizmo"
      gt.needs_id = false
      gt.gizmo_category_id = GizmoCategory.find_by_name("system").id
      gt.return_policy_id = ReturnPolicy.find_by_name("as_is").id
      gt.save!
    end
  end

  def self.down
  end
end
