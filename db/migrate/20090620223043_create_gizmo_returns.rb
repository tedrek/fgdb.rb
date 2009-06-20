class CreateGizmoReturns < ActiveRecord::Migration
  def self.up
    create_table :gizmo_returns do |t|
      t.integer :contact_id
      t.integer :created_by
      t.integer :updated_by
      t.integer :storecredit_difference_cents
      t.text :comments
      t.integer :cashier_created_by
      t.integer :cashier_updated_by

      t.timestamps
    end
    add_column "gizmo_events", "gizmo_return_id", :integer
    add_foreign_key "gizmo_events", "gizmo_return_id", "gizmo_returns", "id", :on_delete => :cascade
    GizmoContext.new({:name => "gizmo_return"}).save!
  end

  def self.down
    drop_table :gizmo_returns
    remove_column "gizmo_events", "gizmo_return_id"
    GizmoContext.find_by_name("gizmo_return").destroy
  end
end
