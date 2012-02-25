class AddBulkGizmoTypeToSales < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gt = GizmoType.new
      gt.name = 'bulk'
      gt.description = 'Bulk'
      gt.rank = 99
      gt.covered = false
      gt.needs_id = false
      gt.parent_name = 'gizmo'
      gt.gizmo_category_id = 4
      gt.suggested_fee_cents = gt.required_fee_cents = 0
      gt.save!
      gc = GizmoContext.sale
      gc.gizmo_types << gt
      gc.save!
    end
  end

  def self.down
    if Default.is_pdx
      gt = GizmoType.find_by_name('bulk')
      gt.destroy
    end
  end
end
