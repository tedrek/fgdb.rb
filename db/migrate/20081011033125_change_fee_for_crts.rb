class ChangeFeeForCrts < ActiveRecord::Migration
  def self.up
    GizmoType.connection.execute("UPDATE gizmo_types SET description='Old Fee CRT', name='old_crt' WHERE description='CRT'")
    GizmoType.connection.execute("UPDATE gizmo_types SET description='Old Fee Sys w/ monitor', name='old_sys_with_monitor' WHERE description='Sys w/ monitor'")
    parent = GizmoType.find_by_description("Monitor")
    {:sys_with_monitor => ["Sys w/ monitor", 1], :crt => ["CRT", 2]}.each do |k,v|
      gt = GizmoType.new(:name => k.to_s, :description => v[0], :parent => parent, :gizmo_contexts => GizmoContext.find(:all).to_a, :gizmo_category_id => v[1], :suggested_fee_cents => 0, :required_fee_cents => 700)
      gt.save!
      DiscountSchedule.find(:all).to_a.map{|x| x.id}.each{|x|
        dsgt = DiscountSchedulesGizmoType.new(:discount_schedule_id => x, :gizmo_type_id => gt.id, :multiplier => nil)
        dsgt.save!
      }
    end
  end

  def self.down
  end
end
