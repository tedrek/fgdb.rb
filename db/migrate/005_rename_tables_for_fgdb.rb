class RenameTablesForFgdb < ActiveRecord::Migration
  def self.up
    rename_table "reports", "spec_sheets"
    rename_table "roles", "actions"
    rename_column "spec_sheets", "role_id", "action_id"
  end

  def self.down
    rename_column "spec_sheets", "action_id", "role_id"
    rename_table "spec_sheets", "reports"
    rename_table "actions", "roles"
  end
end
