class AddServers < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gt = GizmoType.new
      gt.name = 'server'
      gt.description = 'Server'
      gt.covered = false
      gt.gizmo_contexts = [GizmoContext.donation]
      gt.parent_name = 'gizmo'
      gt.needs_id = true
      gt.gizmo_category_id = 1
      gt.required_fee_cents = 500
      gt.suggested_fee_cents = 0
      gt.save!
    end
  end

  def self.down
  end
end
