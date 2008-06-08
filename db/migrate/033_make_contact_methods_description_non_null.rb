class MakeContactMethodsDescriptionNonNull < ActiveRecord::Migration
  def self.up
    User.connection.execute("UPDATE contact_methods SET contact_method_type_id=1 WHERE contact_method_type_id IS NULL")
    User.connection.execute("ALTER TABLE contact_methods ALTER COLUMN contact_method_type_id SET NOT NULL")
  end

  def self.down
    User.connection.execute("ALTER TABLE contact_methods ALTER COLUMN contact_method_type_id DROP NOT NULL")
  end
end
