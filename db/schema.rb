# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 1) do

  create_table "coverage_types", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
  end

  create_table "frequency_types", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
  end

  create_table "holidays", :force => true do |t|
    t.column "name", :string
    t.column "holiday_date", :date
    t.column "is_all_day", :boolean
    t.column "start_time", :time
    t.column "end_time", :time
    t.column "frequency_type_id", :integer
    t.column "schedule_id", :integer
    t.column "weekday_id", :integer
  end

  create_table "jobs", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
    t.column "coverage_type_id", :integer
  end

  create_table "jobs_workers", :id => false, :force => true do |t|
    t.column "job_id", :integer
    t.column "worker_id", :integer
  end

  create_table "meetings", :force => true do |t|
    t.column "name", :string
    t.column "meeting_date", :date
    t.column "start_time", :time
    t.column "end_time", :time
    t.column "splitable", :boolean
    t.column "mergeable", :boolean
    t.column "resizable", :boolean
    t.column "coverage_type_id", :integer
    t.column "frequency_type_id", :integer
    t.column "schedule_id", :integer
    t.column "weekday_id", :integer
  end

  create_table "meetings_workers", :id => false, :force => true do |t|
    t.column "meeting_id", :integer
    t.column "worker_id", :integer
  end

  create_table "schedules", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
    t.column "effective_date", :date
    t.column "ineffective_date", :date
    t.column "parent_id", :integer
    t.column "repeats_every", :integer, :default => 1
    t.column "repeats_on", :integer, :default => 0
    t.column "lft", :integer
    t.column "rgt", :integer
  end

  create_table "standard_shifts", :force => true do |t|
    t.column "start_time", :time
    t.column "end_time", :time
    t.column "splitable", :boolean
    t.column "mergeable", :boolean
    t.column "resizable", :boolean
    t.column "coverage_type_id", :integer
    t.column "job_id", :integer
    t.column "meeting_id", :integer
    t.column "schedule_id", :integer
    t.column "weekday_id", :integer
    t.column "worker_id", :integer, :default => 0
  end

  create_table "unavailabilities", :force => true do |t|
    t.column "effective_date", :date
    t.column "ineffective_date", :date
    t.column "all_day", :boolean
    t.column "start_time", :time
    t.column "end_time", :time
    t.column "repeats_every", :integer, :default => 1
    t.column "repeats_on", :integer, :default => 0
    t.column "weekday_id", :integer
    t.column "worker_id", :integer
  end

  create_table "vacations", :force => true do |t|
    t.column "effective_date", :date
    t.column "ineffective_date", :date
    t.column "is_all_day", :boolean
    t.column "start_time", :time
    t.column "end_time", :time
    t.column "worker_id", :integer
  end

  create_table "weekdays", :force => true do |t|
    t.column "name", :string
    t.column "short_name", :string
    t.column "is_open", :boolean
    t.column "start_time", :time
    t.column "end_time", :time
  end

  create_table "work_shifts", :force => true do |t|
    t.column "shift_date", :date
    t.column "start_time", :time
    t.column "end_time", :time
    t.column "splitable", :boolean
    t.column "mergeable", :boolean
    t.column "resizable", :boolean
    t.column "coverage_type_id", :integer
    t.column "job_id", :integer
    t.column "meeting_id", :integer
    t.column "schedule_id", :integer
    t.column "standard_shift_id", :integer
    t.column "weekday_id", :integer
    t.column "worker_id", :integer
  end

  create_table "worker_types", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
  end

  create_table "workers", :force => true do |t|
    t.column "name", :string
    t.column "weekly_work_hours", :float
    t.column "weekly_admin_hours", :float
    t.column "worker_type_id", :integer
    t.column "contact_id", :integer
  end

end
