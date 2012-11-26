class FixVolunteerTasks < ActiveRecord::Migration
  def self.up
    DB.exec("ALTER TABLE volunteer_task_types ALTER COLUMN effective_on DROP DEFAULT;")
    DB.exec("UPDATE volunteer_task_types SET effective_on = NULL WHERE effective_on = '2009-10-02 22:40:21.818428';")
  end

  def self.down
  end
end
