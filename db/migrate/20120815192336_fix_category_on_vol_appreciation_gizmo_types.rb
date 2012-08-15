class FixCategoryOnVolAppreciationGizmoTypes < ActiveRecord::Migration
  def self.up
    return unless Default.is_pdx
    for i in [300, 600, 1000, 2000, 3000]
      gt = GizmoType.find_by_name("#{i}_volunteer_appreciation_gift")
      gt.gizmo_category_id = GizmoCategory.find_by_name('misc').id
      gt.save!
    end
  end

  def self.down
  end
end
