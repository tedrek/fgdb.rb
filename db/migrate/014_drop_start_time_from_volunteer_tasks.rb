class DropStartTimeFromVolunteerTasks < ActiveRecord::Migration
  def self.up
    add_column :volunteer_tasks, :date_performed, :date
    VolunteerTask.update_all("date_performed = start_time")
    remove_column :volunteer_tasks, :start_time
  end

  def self.down
    add_column :volunteer_tasks, :start_time, :datetime
    VolunteerTask.update_all("start_time = date_performed")
    remove_column :volunteer_tasks, :date_performed
  end
end
