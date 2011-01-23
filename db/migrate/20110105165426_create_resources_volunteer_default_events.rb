class CreateResourcesVolunteerDefaultEvents < ActiveRecord::Migration
  def self.up
    create_table :resources_volunteer_default_events do |t|
      t.integer :volunteer_default_event_id
      t.integer :resource_id
      t.time :start_time
      t.time :end_time
      t.integer :roster_id

      t.timestamps
    end

    add_foreign_key "resources_volunteer_default_events", ["roster_id"], "rosters", ["id"], :on_delete => :restrict
    add_foreign_key "resources_volunteer_default_events", ["volunteer_default_event_id"], "volunteer_default_events", ["id"], :on_delete => :cascade
    add_foreign_key "resources_volunteer_default_events", ["resource_id"], "volunteer_events", ["id"], :on_delete => :restrict
  end

  def self.down
    drop_table :resources_volunteer_default_events
  end
end
