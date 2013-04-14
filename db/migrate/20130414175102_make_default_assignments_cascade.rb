class MakeDefaultAssignmentsCascade < ActiveRecord::Migration
  def self.up
    remove_foreign_key "default_assignments", "default_assignments_volunteer_default_shift_id_fkey"
    remove_foreign_key "default_assignments", "default_assignments_contact_id_fkey"
    add_foreign_key "default_assignments", ["contact_id"], "contacts", ["id"], :on_delete => :cascade
    add_foreign_key "default_assignments", ["volunteer_default_shift_id"], "volunteer_default_shifts", ["id"], :on_delete => :cascade
  end

  def self.down
  end
end
