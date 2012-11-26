class RemoveTheJobsWorkersTable < ActiveRecord::Migration
  def self.up
    drop_table :jobs_workers
  end

  def self.down
  end
end
