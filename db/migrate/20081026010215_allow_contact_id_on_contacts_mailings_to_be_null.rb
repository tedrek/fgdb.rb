class AllowContactIdOnContactsMailingsToBeNull < ActiveRecord::Migration
  def self.up
    Contact.connection.execute("ALTER TABLE contacts_mailings ALTER COLUMN contact_id DROP NOT NULL")
  end

  def self.down
  end
end
