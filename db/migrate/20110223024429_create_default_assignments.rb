class CreateDefaultAssignments < ActiveRecord::Migration
  def self.up
    create_table :default_assignments do |t|
      t.integer :contact_id
      t.integer :volunteer_default_shift_id

      t.timestamps
    end

    add_foreign_key "default_assignments", ["contact_id"], "contacts", ["id"], :on_delete => :cascade
    add_foreign_key "default_assignments", ["volunteer_default_shift_id"], "volunteer_default_shifts", ["id"], :on_delete => :cascade
  end

  def self.down
    drop_table :default_assignments
  end
end
