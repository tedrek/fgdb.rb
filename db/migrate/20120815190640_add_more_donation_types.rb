class AddMoreDonationTypes < ActiveRecord::Migration
  def self.up
    return unless Default.is_pdx

    g_ctx = [GizmoContext.sale, GizmoContext.donation, GizmoContext.disbursement]

    gt = GizmoType.find_by_name('pda_mp3')
    gt.name = 'pda'
    gt.description = 'PDA'
    gt.gizmo_contexts = g_ctx
    gt.save!

    gt = GizmoType.new
    gt.name = "tablet"
    gt.description = "Tablet Computer"
    gt.required_fee_cents = 0
    gt.suggested_fee_cents = 400
    gt.gizmo_category_id = GizmoCategory.find_by_name('system').id
    gt.covered = true
    gt.rank = 13
    gt.parent_name = "gizmo"
    gt.needs_id = true
    gt.return_policy_id = ReturnPolicy.find_by_name('system').id
    gt.gizmo_contexts = [GizmoContext.recycling, *g_ctx]
    gt.save!

    gt = GizmoType.new
    gt.name = "ereader"
    gt.description = "eReader"
    gt.required_fee_cents = 0
    gt.suggested_fee_cents = 100
    gt.gizmo_category_id = GizmoCategory.find_by_name('misc').id
    gt.covered = false
    gt.rank = 99
    gt.parent_name = "gizmo"
    gt.needs_id = false
    gt.return_policy_id = ReturnPolicy.find_by_name('standard').id
    gt.gizmo_contexts = g_ctx
    gt.save!

    gt = GizmoType.new
    gt.name = "smart_phone"
    gt.description = "Smart Phone"
    gt.required_fee_cents = 0
    gt.suggested_fee_cents = 100
    gt.gizmo_category_id = GizmoCategory.find_by_name('misc').id
    gt.covered = false
    gt.rank = 99
    gt.parent_name = "gizmo"
    gt.needs_id = false
    gt.return_policy_id = ReturnPolicy.find_by_name('standard').id
    gt.gizmo_contexts = g_ctx
    gt.save!
  end

  def self.down
  end
end
