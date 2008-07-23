class AddFeeDiscount < ActiveRecord::Migration
  def self.up
    x = GizmoType.new(:description=>"Fee Discount",
                      :parent => GizmoType.find_by_description("root"),
                      :required_fee_cents => 0,
                      :suggested_fee_cents => 0,
                      :gizmo_category_id => GizmoCategory.find_by_description("Misc").id)
    x.save!
    gc = GizmoContext.donation
    gc.gizmo_types << x
    gc.save!
  end

  def self.down
  end
end
