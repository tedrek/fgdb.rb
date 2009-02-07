class SingleTableForStandardShifts < ActiveRecord::Migration
  def self.up
    create_table "shifts", :force => true do |t|
      t.column "type",              :string
      t.column "start_time",        :time
      t.column "end_time",          :time
      t.column "splitable",         :boolean
      t.column "mergeable",         :boolean
      t.column "resizable",         :boolean
      t.column "meeting_name",      :string
      t.column "shift_date",        :date
      t.column "effective_date",    :date
      t.column "ineffective_date",  :date
      t.column "all_day",           :boolean
      t.column "repeats_every",     :integer, :default => 1
      t.column "repeats_on",        :integer, :default => 0
      t.column "coverage_type_id",  :integer
      t.column "frequency_type_id", :integer
      t.column "job_id",            :integer
      t.column "meeting_id",        :integer
      t.column "schedule_id",       :integer
      t.column "weekday_id",        :integer
      t.column "worker_id",         :integer, :default => 0
    end
    execute 'ALTER TABLE shifts ADD CONSTRAINT shifts_coverage_types FOREIGN KEY ( coverage_type_id ) REFERENCES coverage_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE shifts ADD CONSTRAINT shifts_frequency_types FOREIGN KEY ( frequency_type_id ) REFERENCES frequency_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE shifts ADD CONSTRAINT shifts_jobs FOREIGN KEY ( job_id ) REFERENCES jobs( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE shifts ADD CONSTRAINT shifts_meetings FOREIGN KEY ( meeting_id ) REFERENCES meetings( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE shifts ADD CONSTRAINT shifts_schedules FOREIGN KEY ( schedule_id ) REFERENCES schedules( id ) ON DELETE CASCADE'
    execute 'ALTER TABLE shifts ADD CONSTRAINT shifts_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE shifts ADD CONSTRAINT shifts_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE shifts IS \'generic work shifts\' '
    
    execute "INSERT INTO shifts (id, type, meeting_name, shift_date, effective_date, ineffective_date, start_time, end_time, splitable, mergeable, resizable, coverage_type_id, frequency_type_id, schedule_id, weekday_id ) (SELECT id, 'Meeting', name, meeting_date, effective_date, ineffective_date, start_time, end_time, splitable, mergeable, resizable, coverage_type_id, frequency_type_id, schedule_id, weekday_id FROM meetings)"
    execute 'ALTER SEQUENCE shifts_id_seq RESTART WITH 1000'
    execute "INSERT INTO shifts (type, start_time, end_time, splitable, mergeable, resizable, coverage_type_id, job_id, meeting_id, schedule_id, weekday_id, worker_id) (SELECT 'StandardShift', start_time, end_time, splitable, mergeable, resizable, coverage_type_id, job_id, meeting_id, schedule_id, weekday_id, worker_id FROM standard_shifts)"
    execute "INSERT INTO shifts (type, effective_date, ineffective_date, all_day, start_time, end_time, repeats_every, repeats_on, weekday_id, worker_id ) (SELECT 'Unavailability', effective_date, ineffective_date, all_day, start_time, end_time, repeats_every, repeats_on, weekday_id, worker_id FROM unavailabilities)"
    
    execute 'ALTER TABLE meetings_workers DROP CONSTRAINT meetings_workers_meetings'
    execute 'ALTER TABLE standard_shifts DROP CONSTRAINT standard_shifts_meetings '
    execute 'ALTER TABLE work_shifts DROP CONSTRAINT work_shifts_meetings '
    execute 'ALTER TABLE work_shifts DROP CONSTRAINT work_shifts_standard_shifts '
    #rename_column "meetings_workers", "meeting_id", "shift_id"
    execute 'ALTER TABLE meetings_workers ADD CONSTRAINT meetings_workers_meetings FOREIGN KEY ( meeting_id ) REFERENCES shifts( id ) ON DELETE CASCADE'

    execute 'SELECT * INTO TABLE old_work_shifts FROM work_shifts '
    execute 'DROP TABLE work_shifts CASCADE'
    create_table "work_shifts", :force => true do |t|
      t.column "start_time",        :time
      t.column "end_time",          :time
      t.column "splitable",         :boolean
      t.column "mergeable",         :boolean
      t.column "resizable",         :boolean
      t.column "meeting_name",      :string
      t.column "shift_date",        :date
      t.column "effective_date",    :date
      t.column "ineffective_date",  :date
      t.column "all_day",           :boolean
      t.column "repeats_every",     :integer, :default => 1
      t.column "repeats_on",        :integer, :default => 0
      t.column "coverage_type_id",  :integer
      t.column "frequency_type_id", :integer
      t.column "job_id",            :integer
      t.column "meeting_id",        :integer
      t.column "schedule_id",       :integer
      t.column "weekday_id",        :integer
      t.column "worker_id",         :integer, :default => 0
    end
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_coverage_types FOREIGN KEY ( coverage_type_id ) REFERENCES coverage_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_frequency_types FOREIGN KEY ( frequency_type_id ) REFERENCES frequency_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_jobs FOREIGN KEY ( job_id ) REFERENCES jobs( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_meetings FOREIGN KEY ( meeting_id ) REFERENCES meetings( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_schedules FOREIGN KEY ( schedule_id ) REFERENCES schedules( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE work_shifts IS \'shifts on the concrete schedule\' '
  end

  def self.down
    drop_table "shifts"
  end
end
