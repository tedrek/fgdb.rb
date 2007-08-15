class MoveVolunteerTaskCommunityServiceTypesToOwnTable < ActiveRecord::Migration
  def self.up
    create_table :community_service_types do |t|
      t.column "description", :string, :limit => 100
      t.column "hours_multiplier", :float, :limit => 10, :default => 1.0, :null => false
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :integer, :default => 1, :null => false
      t.column "updated_by", :integer, :default => 1, :null => false
    end

    add_column :volunteer_tasks, :community_service_type_id, :integer
    add_column :volunteer_tasks, :volunteer_task_type_id, :integer
    add_column :volunteer_tasks, :start_time, :datetime
    change_column :volunteer_tasks, :duration, :float, :limit => 5, :default => nil, :null => true
    
    VolunteerTask.reset_column_information

    for vt in VolunteerTask.find(:all)
      vt.start_time = vt.date_performed
    end

    remove_column :volunteer_tasks, :date_performed

    CommunityServiceType.reset_column_information

    for vtt in VolunteerTaskType.find_all_by_parent_id(18) 
      CommunityServiceType.create({:id => vtt.id, :description => vtt.description, :hours_multiplier => vtt.hours_multiplier})
      vtt.destroy
    end
    VolunteerTaskType.destroy(18)

    VolunteerTask.reset_column_information

    for vt in VolunteerTask.find(:all)
      vt.community_service_type_id = VolunteerTaskType.find_by_sql(
          ["SELECT vtt.* FROM
              volunteer_task_types vtt, volunteer_tasks vt, volunteer_task_types_volunteer_tasks ah
          WHERE vtt.description = 'school' or
                vtt.description = 'punative' and
                vt.id = ? and
                vt.id = ah.volunteer_task_id and
                vtt.id = ah.volunteer_task_type_id LIMIT 1", vt.id]).id
      vt.volunteer_task_type_id = VolunteerTaskType.find_by_sql(
          ["SELECT vtt.* FROM
              volunteer_task_types vtt, volunteer_tasks vt, volunteer_task_types_volunteer_tasks ah
          WHERE vtt.description != 'school' and
                vtt.description != 'punative' and
                vt.id = ? and
                vt.id = ah.volunteer_task_id and
                vtt.id = ah.volunteer_task_type_id LIMIT 1", vt.id]).id
    end

    drop_table :volunteer_task_types_volunteer_tasks
    remove_column :volunteer_task_types, :required
  end

  def self.down
    add_column :volunteer_tasks, :date_performed, :date
    change_column :volunteer_tasks, :duration, :float, :limit => 5, :default => 0, :null => false

    create_table "volunteer_task_types_volunteer_tasks", :id => false, :force => true do |t|
      t.column "volunteer_task_id", :integer, :null => false
      t.column "volunteer_task_type_id", :integer, :null => false
    end
 
    add_index "volunteer_task_types_volunteer_tasks", ["volunteer_task_id"], :name => "volunteer_task_types_volunteer_tasks_volunteer_task_id_index"

    VolunteerTaskType.create(:id => 18, :description => 'community service', :parent_id => 0, :hours_multiplier => 1, :instantiable => 'f')

    for cst in CommunityServiceType.find(:all)
      unless VolunteerTaskType.exists?(cst.id)
        VolunteerTaskType.create(:id => cst.id, :description => cst.description, :parent_id => 18, :hours_multiplier => cst.hours_multiplier, :instantiable => 't')
      else
        vtt = VolunteerTaskType.create(:description => cst.description, :parent_id => 18, :hours_multiplier => cst.hours_multiplier, :instantiable => 't')
        for vt in VolunteerTask.find_by_community_service_type_id(vtt.id)
          vt.community_service_type_id = vtt.id
          vt.save
        end
      end
    end

    VolunteerTask.reset_column_information

    # here we assume that we have a habtm in app/models/volunteer_task.rb
    for vt in VolunteerTask.find(:all)
      vt.date_performed = vt.start_time
      vt.volunteer_task_types << VolunteerTaskType.find(vt.volunteer_task_type_id)
      vt.volunteer_task_types << VolunteerTaksType.find(vt.community_service_type_id)
      vt.save
    end

    remove_column :volunteer_tasks, :start_time
    remove_column :volunteer_tasks, :community_service_type_id
    remove_column :volunteer_tasks, :volunteer_task_type_id
    drop_table :community_service_types
  end
end
