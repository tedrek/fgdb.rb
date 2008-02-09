class AddForeignKeyIndices < ActiveRecord::Migration
  def self.up
  add_index "jobs", "coverage_type_id"
  add_index "workers", "worker_type_id"
  add_index "workers", "contact_id"
  add_index "jobs_workers", "job_id"
  add_index "jobs_workers", "worker_id"
  add_index "schedules", "lft"
  add_index "schedules", "rgt"
  add_index "meetings", "coverage_type_id"
  add_index "meetings", "frequency_type_id"
  add_index "meetings", "schedule_id"
  add_index "meetings", "weekday_id"
  add_index "standard_shifts", "coverage_type_id"
  add_index "standard_shifts", "job_id"
  add_index "standard_shifts", "meeting_id"
  add_index "standard_shifts", "schedule_id"
  add_index "standard_shifts", "weekday_id"
  add_index "standard_shifts", "worker_id"
  add_index "unavailabilities", "weekday_id"
  add_index "unavailabilities", "worker_id"
  add_index "holidays", "frequency_type_id"
  add_index "holidays", "schedule_id"
  add_index "holidays", "weekday_id"
  add_index "work_shifts", "coverage_type_id"
  add_index "work_shifts", "job_id"
  add_index "work_shifts", "meeting_id"
  add_index "work_shifts", "schedule_id"
  add_index "work_shifts", "standard_shift_id"
  add_index "work_shifts", "weekday_id"
  add_index "work_shifts", "worker_id"
  add_index "vacations", "worker_id"
  end

  def self.down
  end
end
