class MoveAdoptionCreditToVolunteerTasks < ActiveRecord::Migration
  def self.up
    add_column :volunteer_task_types, :adoption_credit, :boolean
    vtt = VolunteerTaskType.find_by_name("laptops")
    vtt.adoption_credit = true
    vtt.save!
  end

  def self.down
  end
end
