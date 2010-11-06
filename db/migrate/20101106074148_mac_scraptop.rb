class MacScraptop < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gt = GizmoType.new
      gt.name = "scraptop_mac"
      gt.description = "Scraptop (Mac)--AS-IS"
      gt.gizmo_category_id = 1
      gt.gizmo_contexts = [GizmoContext.sale]
      gt.parent_name = "gizmo"
      gt.covered = false
      gt.suggested_fee_cents = 0
      gt.required_fee_cents = 0
      gt.rank = 99
      gt.save!
    end
  end

  def self.down
  end
end
