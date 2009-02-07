class AddActualFlag < ActiveRecord::Migration
  def self.up
    add_column "shifts", "actual", :boolean, :default => false
    execute 'UPDATE shifts SET actual = false'
    add_column "work_shifts", "actual", :boolean, :default => true
    execute 'UPDATE work_shifts SET actual = true'
  end

  def self.down
    drop_column "shifts", "actual"
    drop_column "work_shifts", "actual"
  end
end
