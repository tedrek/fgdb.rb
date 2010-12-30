class CreateVolunteerEvents < ActiveRecord::Migration
  def self.up
    create_table :volunteer_events do |t|
      t.string :description
      t.integer :volunteer_default_event_id
      t.date :date

      t.timestamps
    end
    add_foreign_key "volunteer_events", ["volunteer_default_event_id"], "volunteer_default_events", ["id"], :on_delete => :set_null

#    remove_column :volunteer_shifts, :date
#    add_column :volunteer_shifts, :volunteer_event_id, :integer, :null => false
#    add_foreign_key "volunteer_shifts", ["volunteer_event_id"], "volunteer_events", ["id"], :on_delete => :cascade
  end

  def self.down
    drop_table :volunteer_events
  end
end
