class AddOneTimeDiscount < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      ds = DiscountSchedule.new(:name => "one_time", :description => "one time")
      ds.discount_schedules_gizmo_types << DiscountSchedulesGizmoType.new(:gizmo_type => GizmoType.find_all_by_name("gizmo").select{|x| x.effective_on?(Date.today)}.first, :multiplier => 0.85)
      ds.discount_schedules_gizmo_types << DiscountSchedulesGizmoType.new(:gizmo_type => GizmoType.find_all_by_name("store_credit").select{|x| x.effective_on?(Date.today)}.first, :multiplier => 1.0)
      ds.save!
    end
  end

  def self.down
  end
end
