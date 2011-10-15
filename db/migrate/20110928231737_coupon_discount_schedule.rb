class CouponDiscountSchedule < ActiveRecord::Migration
  def self.up
    d = DiscountSchedule.new
    d.name = 'coupon'
    d.description = 'coupon'
    d.save!
    dsgt = DiscountSchedulesGizmoType.new
    dsgt.gizmo_type = GizmoType.find_by_name_and_ineffective_on('gizmo', nil)
    dsgt.discount_schedule = d
    dsgt.multiplier = 0.75
    dsgt.save!
  end

  def self.down
    ds = DiscountSchedule.find_by_name('coupon')
    ds.destroy if ds
  end
end
