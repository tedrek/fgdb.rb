class AddVintageAsIsGizmoTypes < ActiveRecord::Migration
  def self.up
    for i in [['gizmo', 'misc'], ['mac', 'system'], ['system', 'system'], ['game', 'misc']]
      ad = GizmoType.new
      ad.gizmo_category = GizmoCategory.find_by_name(i.last)
      ad.parent_name = 'gizmo'
      ad.suggested_fee_cents = 0
      ad.required_fee_cents = 0
      ad.covered = false
      ad.needs_id = false
      ad.rank = 99
      ad.name = "vintage_#{i.first}"
      ad.description = "Vintage #{i.first.titleize}-As Is"
      ad.gizmo_contexts = [GizmoContext.sale]
      ad.save!
    end
  end

  def self.down
  end
end
