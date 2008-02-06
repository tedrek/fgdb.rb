class IndexForExpandedReports < ActiveRecord::Migration
  def self.up
    add_index :contacts, :created_at
    add_index :donations, :contact_id
    add_index :sales, :contact_id
    add_index :disbursements, :contact_id
  end

  def self.down
    remove_index :disbursements, :contact_id
    remove_index :sales, :contact_id
    remove_index :donations, :contact_id
    remove_index :contacts, :created_at
  end
end
