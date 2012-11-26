class AddFieldsToDisktest < ActiveRecord::Migration
  def self.up
    add_column :disktest_runs, :bus_type, :string
    add_column :disktest_runs, :failure_details, :string
    add_column :disktest_runs, :started_at, :timestamp
    DB.exec("UPDATE disktest_runs SET started_at = created_at;")
  end

  def self.down
  end
end
