class AddFkeysToSkjedjuling < ActiveRecord::Migration
  def self.up
    add_foreign_key "rosters_skeds", ["roster_id"], "rosters", ["id"], :on_delete => :cascade
    add_foreign_key "rosters_skeds", ["sked_id"], "skeds", ["id"], :on_delete => :cascade
    add_foreign_key "volunteer_default_shifts", ["volunteer_task_type_id"], "volunteer_task_types", ["id"], :on_delete => :restrict
    add_foreign_key "volunteer_default_shifts", ["roster_id"], "rosters", ["id"], :on_delete => :cascade
    add_foreign_key "volunteer_shifts", ["volunteer_default_shift_id"], "volunteer_default_shifts", ["id"], :on_delete => :set_null
    add_foreign_key "volunteer_shifts", ["volunteer_task_type_id"], "volunteer_task_types", ["id"], :on_delete => :restrict
    add_foreign_key "volunteer_shifts", ["roster_id"], "rosters", ["id"], :on_delete => :cascade
    add_foreign_key "assignments", ["volunteer_shift_id"], "volunteer_shifts", ["id"], :on_delete => :cascade
    add_foreign_key "assignments", ["contact_id"], "contacts", ["id"], :on_delete => :cascade
  end

  def self.down
    remove_foreign_key "rosters_skeds", "rosters_skeds_roster_id_fkey"
    remove_foreign_key "rosters_skeds", "rosters_skeds_sked_id_fkey"
    remove_foreign_key "volunteer_default_shifts", "volunteer_default_shifts_volunteer_task_type_id_fkey"
    remove_foreign_key "volunteer_default_shifts", "volunteer_default_shifts_roster_id_fkey"
    remove_foreign_key "volunteer_shifts", "volunteer_shifts_volunteer_default_shift_id_fkey"
    remove_foreign_key "volunteer_shifts", "volunteer_shifts_volunteer_task_type_id_fkey"
    remove_foreign_key "volunteer_shifts", "volunteer_shifts_roster_id_fkey"
    remove_foreign_key "assignments", "assignments_volunteer_shift_id_fkey"
    remove_foreign_key "assignments", "assignments_contact_id_fkey"
  end
end
