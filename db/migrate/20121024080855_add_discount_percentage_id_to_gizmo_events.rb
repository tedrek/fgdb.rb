class AddDiscountPercentageIdToGizmoEvents < ActiveRecord::Migration
  def self.up
    add_column :gizmo_types, :not_discounted, :boolean, :default => false, :null => false
    for i in ["gift_cert", "store_credit"]
      gt = GizmoType.find_by_name(i)
      gt.not_discounted = true
      gt.save!
    end

    add_column :gizmo_events, :discount_percentage_id, :integer
    add_foreign_key :gizmo_events, :discount_percentage_id, :discount_percentages, :id, :on_delete => :restrict

    DB.exec("UPDATE gizmo_events SET discount_percentage_id = discount_percentages.id FROM sales, gizmo_types, discount_schedules_gizmo_types, discount_percentages WHERE sales.id = gizmo_events.sale_id AND gizmo_types.id = gizmo_events.gizmo_type_id AND gizmo_types.not_discounted = 'f' AND discount_schedules_gizmo_types.discount_schedule_id = sales.discount_schedule_id AND discount_schedules_gizmo_types.gizmo_type_id = gizmo_events.gizmo_type_id AND percentage = (100 - (multiplier * 100)) AND sales.discount_percentage_id != discount_percentages.id;")
  end

  def self.down
    remove_column :gizmo_types, :not_discounted
    remove_column :gizmo_events, :discount_percentage_id
  end
end
