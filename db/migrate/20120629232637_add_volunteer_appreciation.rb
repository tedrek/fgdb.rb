class AddVolunteerAppreciation < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      d = DisbursementType.new
      d.name = "volunteer_appreciation_gifts"
      d.description = "Vol Appreciation Gifts"
      d.save!

      for i in [300, 600, 1000, 2000, 3000]
        g = GizmoType.new
        g.name = "#{i}_volunteer_appreciation_gift"
        if i == 3000
          g.description = "Vol Appreciation Gift, #{i}+ hours"
        else
          g.description = "Vol Appreciation Gift, #{i} hours"
        end
        g.required_fee_cents = 0
        g.suggested_fee_cents = 0
        g.gizmo_category_id = GizmoCategory.find_by_name('misc').id
        g.covered = false
        g.rank = 99
        g.parent_name = "gizmo"
        g.needs_id = false
        g.return_policy_id = nil
        g.gizmo_contexts << GizmoContext.disbursement
        g.save!
      end
    end
  end

  def self.down
  end
end
