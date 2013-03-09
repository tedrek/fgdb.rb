class AddCgsType < ActiveRecord::Migration
  def self.up
    ad = GizmoType.new
    ad.gizmo_category = GizmoCategory.find_by_name('misc')
    ad.parent_name = 'gizmo'
    ad.suggested_fee_cents = 0
    ad.required_fee_cents = 0
    ad.covered = false
    ad.needs_id = false
    ad.rank = 99
    ad.name = 'cgs'
    ad.description = 'CGS'
    ad.gizmo_contexts = [GizmoContext.sale]
    ad.save!
  end

  def self.down
  end
end
