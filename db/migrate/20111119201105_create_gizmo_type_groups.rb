class CreateGizmoTypeGroups < ActiveRecord::Migration
  def self.up
    create_table :gizmo_type_groups do |t|
      t.string :name

      t.timestamps
    end
    create_table :gizmo_type_groups_gizmo_types, :id => false do |t|
      t.integer :gizmo_type_id
      t.integer :gizmo_type_group_id
    end
    add_foreign_key :gizmo_type_groups_gizmo_types, :gizmo_type_id, :gizmo_types, :id, :on_delete => :cascade
    add_foreign_key :gizmo_type_groups_gizmo_types, :gizmo_type_group_id, :gizmo_type_groups, :id, :on_delete => :cascade
    Privilege.new(:name => 'manage_gizmo_type_groups').save!
  end

  def self.down
    drop_table :gizmo_type_groups
    drop_table :gizmo_type_groups_gizmo_types
    Privilege.find_by_name('manage_gizmo_type_groups').destroy!
  end
end
