class IndexingForSpeed < ActiveRecord::Migration
  def self.up
    add_index :donations, :created_at
    add_index :sales, :created_at
    add_index :recyclings, :created_at
    add_index :dispersements, :created_at
    add_index :gizmo_events, :donation_id
    add_index :gizmo_events, :sale_id
    add_index :gizmo_events, :dispersement_id
    add_index :gizmo_events, :recycling_id
    add_index :gizmo_events, :created_at
    add_index :payments, :donation_id
    add_index :payments, :sale_id
    add_index :volunteer_tasks, :contact_id
    add_index :volunteer_task_types_volunteer_tasks, :volunteer_task_id
    add_index :contact_methods, :contact_id
  end

  def self.down
    remove_index :donations, :created_at
    remove_index :sales, :created_at
    remove_index :recyclings, :created_at
    remove_index :dispersements, :created_at
    remove_index :gizmo_events, :donation_id
    remove_index :gizmo_events, :sale_id
    remove_index :gizmo_events, :dispersement_id
    remove_index :gizmo_events, :recycling_id
    remove_index :gizmo_events, :created_at
    remove_index :payments, :donation_id
    remove_index :payments, :sale_id
    remove_index :volunteer_tasks, :contact_id
    remove_index :volunteer_task_types_volunteer_tasks, :volunteer_task_id
    remove_index :contact_methods, :contact_id
  end
end
