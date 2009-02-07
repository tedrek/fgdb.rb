class AddConstaintsToJoinTables < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE meetings_workers ADD CONSTRAINT meetings_workers_link UNIQUE ( meeting_id, worker_id )'
    execute 'ALTER TABLE jobs_workers ADD CONSTRAINT jobs_workers_link UNIQUE ( job_id, worker_id )'
  end

  def self.down
    execute 'ALTER TABLE meetings_workers DROP CONSTRAINT meetings_workers_link'
    execute 'ALTER TABLE jobs_workers DROP CONSTRAINT jobs_workers_link'
  end
end
