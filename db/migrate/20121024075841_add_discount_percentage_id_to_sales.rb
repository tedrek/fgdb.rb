class AddDiscountPercentageIdToSales < ActiveRecord::Migration
  def self.up
    add_column :sales, :discount_percentage_id, :integer, :null => false, :default => DiscountPercentage.find_by_percentage(0).id
    add_foreign_key :sales, :discount_percentage_id, :discount_percentages, :id, :on_delete => :restrict

    DB.exec("UPDATE sales SET discount_percentage_id = discount_percentages.id FROM gizmo_types, discount_schedules_gizmo_types, discount_percentages WHERE gizmo_types.name = 'gizmo' AND (gizmo_types.effective_on IS NULL or gizmo_types.effective_on <= sales.created_at) AND (gizmo_types.ineffective_on IS NULL or gizmo_types.ineffective_on > sales.created_at) AND discount_schedules_gizmo_types.discount_schedule_id = sales.discount_schedule_id AND discount_schedules_gizmo_types.gizmo_type_id = gizmo_types.id AND percentage = (100 - (multiplier * 100));")
  end

  def self.down
    remove_column :sales, :discount_percentage_id
  end
end
