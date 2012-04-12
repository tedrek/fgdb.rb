class AddMacAsIsTypes < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gt = GizmoType.find_by_name('laptop_parts')
      if gt
        gt.name = 'laptop_as_is'
        gt.gizmo_category_id = GizmoCategory.find_by_name('system').id
        gt.save!
      end

      gt = GizmoType.new
      gt.description = "Laptop (Mac) As-Is"
      gt.name = "laptop_mac_as_is"
      gt.return_policy_id = ReturnPolicy.find_by_name('as_is').id
      gt.gizmo_contexts = [GizmoContext.sale]
      gt.covered = false
      gt.suggested_fee_cents = 0
      gt.required_fee_cents = 0
      gt.parent_name = "gizmo"
      gt.needs_id = false
      gt.gizmo_category_id = GizmoCategory.find_by_name('system').id
      gt.save!

      gt = GizmoType.new
      gt.description = "System w/ LCD (Mac) As-Is"
      gt.name = "system_lcd_mac_as_is"
      gt.return_policy_id = ReturnPolicy.find_by_name('as_is').id
      gt.gizmo_contexts = [GizmoContext.sale]
      gt.covered = false
      gt.suggested_fee_cents = 0
      gt.required_fee_cents = 0
      gt.parent_name = "gizmo"
      gt.needs_id = false
      gt.gizmo_category_id = GizmoCategory.find_by_name('system').id
      gt.save!

      gt = GizmoType.new
      gt.description = "System (Mac) As-Is"
      gt.name = "system_mac_as_is"
      gt.return_policy_id = ReturnPolicy.find_by_name('as_is').id
      gt.gizmo_contexts = [GizmoContext.sale]
      gt.covered = false
      gt.suggested_fee_cents = 0
      gt.required_fee_cents = 0
      gt.parent_name = "gizmo"
      gt.needs_id = false
      gt.gizmo_category_id = GizmoCategory.find_by_name('system').id
      gt.save!
    end
  end

  def self.down
  end
end
