class Temp < ActiveRecord::Migration
  def self.up
    create_table "work_shifts", :force => true do |t|
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
      t.column "shift_id",          :integer
      t.column "weekday_id",        :integer
      t.column "worker_id",         :integer, :default => 0
    end

    execute 'INSERT INTO work_shifts (type, start_time, end_time, splitable, mergeable, resizable, meeting_name, shift_date, effective_date, ineffective_date, all_day, repeats_every, repeats_on, coverage_type_id, frequency_type_id, job_id, meeting_id, schedule_id, shift_id, weekday_id, worker_id) (SELECT \'StandardShift\', start_time, end_time, splitable, mergeable, resizable, NULL, shift_date, \'1910-12-22\', \'2100-12-31\', true, 1, 0, coverage_type_id, NULL, job_id, meeting_id, schedule_id, NULL, weekday_id, worker_id FROM old_work_shifts)'
    execute 'UPDATE work_shifts SET type = \'Meeting\' WHERE meeting_id IS NOT NULL'
    execute 'UPDATE work_shifts SET meeting_name = (SELECT name FROM meetings WHERE meetings.id = work_shifts.meeting_id) WHERE work_shifts.type = \'Meeting\''
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_coverage_types FOREIGN KEY ( coverage_type_id ) REFERENCES coverage_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_frequency_types FOREIGN KEY ( frequency_type_id ) REFERENCES frequency_types( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_jobs FOREIGN KEY ( job_id ) REFERENCES jobs( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_meetings FOREIGN KEY ( meeting_id ) REFERENCES meetings( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_schedules FOREIGN KEY ( schedule_id ) REFERENCES schedules( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_weekdays FOREIGN KEY ( weekday_id ) REFERENCES weekdays( id ) ON DELETE SET NULL'
    execute 'ALTER TABLE work_shifts ADD CONSTRAINT work_shifts_workers FOREIGN KEY ( worker_id ) REFERENCES workers( id ) ON DELETE SET NULL'
    execute 'COMMENT ON TABLE work_shifts IS \'shifts on the concrete schedule\' '
    #execute 'DROP TABLE old_work_shifts CASCADE'
  end

  def self.down
  end
end
