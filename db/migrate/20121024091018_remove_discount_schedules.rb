class RemoveDiscountSchedules < ActiveRecord::Migration
  def self.up
    drop_table :discount_schedules
    remove_column :sales, :discount_schedule_id
    drop_table :discount_schedules_gizmo_types
  end

  def self.down
  end
end
