class AddDropoutType < ActiveRecord::Migration
  def self.up
    Contact.connection.execute("INSERT INTO contact_types (description, for_who) VALUES ('dropout', 'per');")
  end

  def self.down
  end
end
