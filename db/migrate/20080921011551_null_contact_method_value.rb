class NullContactMethodValue < ActiveRecord::Migration
  def self.up
    ["DELETE FROM contact_methods WHERE value IS NULL",
      "ALTER TABLE contact_methods ALTER value SET NOT NULL"].each do |sql|
      ContactMethod.connection.execute(sql)
    end
  end

  def self.down
    ContactMethod.connection.execute("ALTER TABLE contact_methods ALTER value SET NULL")
  end
end
