class AddTshirtType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      schwag = GizmoType.find_by_name_and_ineffective_on('schwag', nil)
      schwag.description = "Sticker"
      schwag.save

      {"t_shirt" => "T-Shirt", "tote_bag" => "Tote Bag"}.each do |k,v|
        new = GizmoType.new
        new.description = v
        new.name = k
        new.effective_on = Date.today
        new.parent_name = 'gizmo'
        new.needs_id = false
        new.required_fee_cents = 0
        new.suggested_fee_cents = 0
        new.not_discounted = false
        new.rank = 99
        new.covered = false
        new.gizmo_category = GizmoCategory.find_by_name("misc")
        new.gizmo_contexts = [GizmoContext.sale]
        new.save!
      end
    end
  end

  def self.down
  end
end
