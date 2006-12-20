class CreateDiscountSchedulesGizmoTypes < ActiveRecord::Migration
  def self.up
    create_table :discount_schedules_gizmo_types do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :discount_schedules_gizmo_types
  end
end
