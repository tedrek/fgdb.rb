class Skedjulator < ActiveRecord::Migration

  def self.up
    create_table "weekdays", :force => true do |t|
      t.column "name",       :string
      t.column "short_name", :string
      t.column "is_open",    :boolean
      t.column "start_time", :time
      t.column "end_time",   :time
    end

    execute 'COMMENT ON TABLE weekdays IS \'e.g. Sunday, Monday, etc.\' '
    create_table "coverage_types", :force => true do |t|
      t.column "name",        :string
      t.column "description", :string
    end
    execute 'COMMENT ON TABLE coverage_types IS \'e.g. floatable or anchored\' '
  
    create_table "frequency_types", :force => true do |t|
      t.column "name",        :string
      t.column "description", :string
    end
    execute 'COMMENT ON TABLE frequency_types IS \'e.g. monthly, weekly, daily, etc.\' '
  
    create_table "worker_types", :force => true do |t|
      t.column "name",        :string
      t.column "description", :string
    end
    execute 'COMMENT ON TABLE worker_types IS \'e.g. full-time or substitute\' '
  
    create_table "jobs", :force => true do |t|
      t.column "name",             :string
      t.column "description",      :string
      t.column "coverage_type_id", :integer
    end
    execute 'ALTER TABLE jobs ADD CONSTRAINT jobs_coverage_types FOREIGN KEY ( coverage_type_id ) REFERENCES coverage_types( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE jobs IS \'jobs that workers do during shifts\' '

    create_table "workers", :force => true do |t|
      t.column "name",           :string
      t.column "weekly_work_hours",  :float
      t.column "weekly_admin_hours", :float
      t.column "worker_type_id", :integer
      t.column "contact_id",     :integer
    end
    execute 'ALTER TABLE workers ADD CONSTRAINT workers_worker_types FOREIGN KEY ( worker_type_id ) REFERENCES worker_types( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE workers IS \'people who may fill shifts on the schedule\' '

    create_table "jobs_workers", :id => false, :force => true do |t|
      t.column "job_id",    :integer
      t.column "worker_id", :integer
    end
    execute 'ALTER TABLE jobs_workers ADD CONSTRAINT jobs_workers_jobs FOREIGN KEY ( job_id ) REFERENCES jobs( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE jobs_workers ADD CONSTRAINT jobs_workers_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE CASCADE'
    execute 'COMMENT ON TABLE jobs_workers IS \'link table, allows jobs to be performed by workers\' '
  
    create_table "schedules", :force => true do |t|
      t.column "name",             :string
      t.column "description",      :string
      t.column "effective_date",   :date
      t.column "ineffective_date", :date
      t.column "parent_id",        :integer
      t.column "repeats_every",    :integer, :default => 1
      t.column "repeats_on",       :integer, :default => 0
      t.column "lft",              :integer
      t.column "rgt",              :integer
    end
    execute 'ALTER TABLE schedules ADD CONSTRAINT schedules_schedules FOREIGN KEY ( parent_id ) REFERENCES schedules( id ) ON DELETE CASCADE'
    execute 'COMMENT ON TABLE schedules IS \'collection of all shifts being performed in a given date range\' '
  
    create_table "meetings", :force => true do |t|
      t.column "name",              :string
      t.column "meeting_date",      :date
      t.column "start_time",        :time
      t.column "end_time",          :time
      t.column "splitable",         :boolean
      t.column "mergeable",         :boolean
      t.column "resizable",         :boolean
      t.column "coverage_type_id",  :integer
      t.column "frequency_type_id", :integer
      t.column "schedule_id",       :integer
      t.column "weekday_id",        :integer
    end
    execute 'ALTER TABLE meetings ADD CONSTRAINT meetings_coverage_types FOREIGN KEY ( coverage_type_id ) REFERENCES coverage_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE meetings ADD CONSTRAINT meetings_frequency_types FOREIGN KEY ( frequency_type_id ) REFERENCES frequency_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE meetings ADD CONSTRAINT meetings_schedules FOREIGN KEY ( schedule_id ) REFERENCES schedules( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE meetings ADD CONSTRAINT meetings_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE meetings IS \'work shifts that are shared by multiple workers\' '
  
    create_table "standard_shifts", :force => true do |t|
      t.column "start_time",       :time
      t.column "end_time",         :time
      t.column "splitable",        :boolean
      t.column "mergeable",        :boolean
      t.column "resizable",        :boolean
      t.column "coverage_type_id", :integer
      t.column "job_id",           :integer
      t.column "meeting_id",       :integer
      t.column "schedule_id",      :integer
      t.column "weekday_id",       :integer
      t.column "worker_id",        :integer, :default => 0
    end
    execute 'ALTER TABLE standard_shifts ADD CONSTRAINT standard_shifts_coverage_types FOREIGN KEY ( coverage_type_id ) REFERENCES coverage_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE standard_shifts ADD CONSTRAINT standard_shifts_jobs FOREIGN KEY ( job_id ) REFERENCES jobs( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE standard_shifts ADD CONSTRAINT standard_shifts_meetings FOREIGN KEY ( meeting_id ) REFERENCES meetings( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE standard_shifts ADD CONSTRAINT standard_shifts_schedules FOREIGN KEY ( schedule_id ) REFERENCES schedules( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE standard_shifts ADD CONSTRAINT standard_shifts_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE standard_shifts ADD CONSTRAINT standard_shifts_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE standard_shifts IS \'shifts that have not been filled by workers yet\' '
  
    create_table "unavailabilities", :force => true do |t|
      t.column "effective_date",     :date
      t.column "ineffective_date",   :date
      t.column "all_day",        :boolean
      t.column "start_time",     :time
      t.column "end_time",       :time
      t.column "repeats_every",    :integer, :default => 1
      t.column "repeats_on",       :integer, :default => 0
      t.column "weekday_id",          :integer
      t.column "worker_id",          :integer
    end
    execute 'ALTER TABLE unavailabilities ADD CONSTRAINT unavailabilities_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE unavailabilities ADD CONSTRAINT unavailabilities_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE CASCADE'
    execute 'COMMENT ON TABLE unavailabilities IS \'describes when a worker is unavailable for work\' '
  
    create_table "holidays", :force => true do |t|
      t.column "name",              :string
      t.column "holiday_date",      :date
      t.column "is_all_day",        :boolean
      t.column "start_time",        :time
      t.column "end_time",          :time
      t.column "frequency_type_id", :integer
      t.column "schedule_id",       :integer
      t.column "weekday_id",        :integer
    end
    execute 'ALTER TABLE holidays ADD CONSTRAINT holidays_frequency_types FOREIGN KEY ( frequency_type_id ) REFERENCES frequency_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE holidays ADD CONSTRAINT holidays_schedules FOREIGN KEY ( schedule_id ) REFERENCES schedules( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE holidays ADD CONSTRAINT holidays_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE holidays IS \'dates or time ranges when no work needs to be scheduled\' '
  
    create_table "meetings_workers", :id => false, :force => true do |t|
      t.column "meeting_id", :integer
      t.column "worker_id",  :integer
    end
    execute 'ALTER TABLE meetings_workers ADD CONSTRAINT meetings_workers_meetings FOREIGN KEY ( meeting_id ) REFERENCES meetings( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE meetings_workers ADD CONSTRAINT meetings_workers_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE CASCADE'
    execute 'COMMENT ON TABLE meetings_workers IS \'link table, workers attend which meetings\' '
  
    create_table "work_shifts", :force => true do |t|
      t.column "shift_date",        :date
      t.column "start_time",        :time
      t.column "end_time",          :time
      t.column "splitable",         :boolean
      t.column "mergeable",         :boolean
      t.column "resizable",         :boolean
      t.column "coverage_type_id", :integer
      t.column "job_id",            :integer
      t.column "meeting_id",       :integer
      t.column "schedule_id",       :integer
      t.column "standard_shift_id", :integer
      t.column "weekday_id",        :integer
      t.column "worker_id",         :integer
    end
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_coverage_types FOREIGN KEY ( coverage_type_id ) REFERENCES coverage_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_jobs FOREIGN KEY ( job_id ) REFERENCES jobs( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_meetings FOREIGN KEY ( meeting_id ) REFERENCES meetings( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_schedules FOREIGN KEY ( schedule_id ) REFERENCES schedules( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_standard_shifts FOREIGN KEY ( standard_shift_id ) REFERENCES standard_shifts( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE work_shifts IS \'shifts that have been assigned to workers\' '
  
    create_table "vacations", :force => true do |t|
      t.column "effective_date",   :date
      t.column "ineffective_date", :date
      t.column "is_all_day",       :boolean
      t.column "start_time",       :time
      t.column "end_time",         :time
      t.column "worker_id",        :integer
    end
    execute 'ALTER TABLE vacations ADD CONSTRAINT vacations_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE CASCADE'
    execute 'COMMENT ON TABLE vacations IS \'dates or time ranges when a worker is ununavailable for work\' '
  end

  def self.down
    drop_table "coverage_types"
    drop_table "frequency_types"
    drop_table "holidays"
    drop_table "jobs"
    drop_table "jobs_workers"
    drop_table "meetings"
    drop_table "meetings_workers"
    drop_table "schedules"
    drop_table "standard_shifts"
    drop_table "unavailabilities"
    drop_table "vacations"
    drop_table "weekdays"
    drop_table "work_shifts"
    drop_table "worker_types"
    drop_table "workers"
  end
end
