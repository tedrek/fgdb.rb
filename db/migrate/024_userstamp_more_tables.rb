class UserstampMoreTables < ActiveRecord::Migration

  TABLES = [ "volunteer_tasks", "contacts", "users" ]

  def self.up
    TABLES.each {|table|
      add_column table, :created_by, :bigint, :null => false, :default => 1
      add_column table, :updated_by, :bigint
      Contact.connection.execute("ALTER TABLE #{table} ALTER COLUMN created_by DROP DEFAULT")
    }
  end

  def self.down
    TABLES.each {|table|
      remove_column table, :created_by
      remove_column table, :updated_by
    }
  end
end
