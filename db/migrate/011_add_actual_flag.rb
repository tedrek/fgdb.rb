class AddActualFlag < ActiveRecord::Migration
  def self.up
    add_column "shifts", "actual", :boolean, :default => false
    execute_sql 'UPDATE shifts SET actual = false'
    add_column "work_shifts", "actual", :boolean, :default => true
    execute_sql 'UPDATE work_shifts SET actual = true'
  end

  def self.down
    drop_column "shifts", "actual"
    drop_column "work_shifts", "actual"
  end
end
