class AddGameGizmoType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gt = GizmoType.new
      gt.description = "Game"
      gt.name = "game"
      gt.gizmo_contexts = [GizmoContext.sale, GizmoContext.donation]
      gt.covered = false
      gt.suggested_fee_cents = 0
      gt.required_fee_cents = 0
      gt.parent_name = "gizmo"
      gt.needs_id = false
      gt.gizmo_category_id = 4
      gt.save!
    end
  end

  def self.down
  end
end
