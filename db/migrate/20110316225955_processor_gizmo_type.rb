class ProcessorGizmoType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gc = GizmoCategory.find_by_name("misc")
      gct = GizmoContext.sale
      gt = GizmoType.new
      gt.name = "processor"
      gt.description = "Processor"
      gt.rank = 99
      gt.covered = false
      gt.required_fee_cents = 0
      gt.suggested_fee_cents = 0
      gt.gizmo_category = gc
      gt.parent_name = "gizmo"
      gt.gizmo_contexts = [gct]
      gt.save!
    end
  end

  def self.down
    g = GizmoType.find_by_name("processor")
    if g
      g.destroy
    end
  end
end
