class FixUpUserstamps < ActiveRecord::Migration
  def self.up
    remove_column "spec_sheets", "created_by"
    remove_column "spec_sheets", "updated_by"
    remove_column "systems", "created_by"
    remove_column "systems", "updated_by"
    add_column "disbursements", "created_by", :integer
    add_column "disbursements", "updated_by", :integer
    add_column "recyclings", "created_by", :integer
    add_column "recyclings", "updated_by", :integer
    c = Contact.connection
    c.execute("UPDATE disbursements SET created_by = 1")
    c.execute("ALTER TABLE disbursements ALTER created_by SET NOT NULL")
    c.execute("UPDATE recyclings SET created_by = 1")
    c.execute("UPDATE disbursements SET updated_by = 1 WHERE updated_at IS NOT NULL")
    c.execute("UPDATE recyclings SET updated_by = 1 WHERE updated_at IS NOT NULL")
    c.execute("UPDATE disbursements SET created_by = logs.user_id FROM logs WHERE logs.thing_id = disbursements.id AND table_name = 'disbursements' AND action = 'create' AND (disbursements.created_by = 1);")
    c.execute("UPDATE disbursements SET updated_by = logs.user_id FROM logs WHERE logs.thing_id = disbursements.id AND table_name = 'disbursements' AND action = 'update' AND (disbursements.updated_by = 1);")
    c.execute("UPDATE recyclings SET created_by = logs.user_id FROM logs WHERE logs.thing_id = recyclings.id AND table_name = 'recyclings' AND action = 'create' AND (recyclings.created_by = 1);")
    c.execute("UPDATE recyclings SET updated_by = logs.user_id FROM logs WHERE logs.thing_id = recyclings.id AND table_name = 'recyclings' AND action = 'update' AND (recyclings.updated_by = 1);")
  end

  def self.down
  end
end
