class FixMiscAsIs < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      gt = GizmoType.find_by_name("misc_item_as_is")
      gt.parent_name = "gizmo"
      gt.save!
    end
  end

  def self.down
  end
end
