class CreateVolunteerDefaultEvents < ActiveRecord::Migration
  def self.up
    create_table :volunteer_default_events do |t|
      t.string :description
      t.integer :weekday_id, :null => false

      t.timestamps
    end

    remove_column :volunteer_default_shifts, :weekday_id
    add_column :volunteer_default_shifts, :volunteer_default_event_id, :integer, :null => false
    add_foreign_key "volunteer_default_shifts", ["volunteer_default_event_id"], "volunteer_default_events", ["id"], :on_delete => :cascade
  end

  def self.down
    drop_table :volunteer_default_events
  end
end
