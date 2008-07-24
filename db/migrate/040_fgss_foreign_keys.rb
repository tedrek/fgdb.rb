class FgssForeignKeys < ActiveRecord::Migration
  def self.up
    add_foreign_key "spec_sheets", [:contact_id], "contacts", [:id]
    add_foreign_key "spec_sheets", [:system_id], "systems", [:id]
    add_foreign_key "spec_sheets", [:action_id], "actions", [:id]
    add_foreign_key "spec_sheets", [:type_id], "types", [:id]
  end

  def self.down
  end
end
