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
    add_foreign_key :volunteer_tasks, ["community_service_type_id"], "community_service_types", ["id"], :on_delete => :set_null
    add_column :volunteer_tasks, :volunteer_task_type_id, :integer
    add_foreign_key :volunteer_tasks, ["volunteer_task_type_id"], "volunteer_task_types", ["id"], :on_delete => :set_null

    sql = "DELETE from volunteer_task_types_volunteer_tasks WHERE volunteer_task_type_id = 0"
    VolunteerTask.connection.execute(sql)

    cs = VolunteerTaskType.find(:first, :conditions => ["description = ?", "community service"])
    if cs
      new_service_types = {}
      service_types = VolunteerTaskType.find_all_by_parent_id(cs.id)
      for vtt in service_types
        new_service_types[vtt] = CommunityServiceType.create({ :description => vtt.description,
                                                               :hours_multiplier => vtt.hours_multiplier })
      end

      # move many-to-many assoc. over to two one-to-many assocs.
      old_ids = service_types.map {|st| st.id.to_s}.join(',')
      sql = "UPDATE volunteer_tasks " +
        "SET volunteer_task_type_id = volunteer_task_types_volunteer_tasks.volunteer_task_type_id  " +
        "FROM volunteer_task_types_volunteer_tasks " +
        "WHERE volunteer_task_types_volunteer_tasks.volunteer_task_id = volunteer_tasks.id " +
        "AND volunteer_task_types_volunteer_tasks.volunteer_task_type_id NOT IN (#{old_ids}) " +
        "AND volunteer_tasks.volunteer_task_type_id IS NULL; " +
        "UPDATE volunteer_tasks " +
        "SET community_service_type_id = CASE "
      new_service_types.each {|old,new|
        sql += "WHEN volunteer_task_types_volunteer_tasks.volunteer_task_type_id = %d THEN %d " % [old.id, new.id]
      }
      sql += "ELSE Null END " +
        "FROM volunteer_task_types_volunteer_tasks " +
        "WHERE volunteer_task_types_volunteer_tasks.volunteer_task_id = volunteer_tasks.id " +
        "AND volunteer_task_types_volunteer_tasks.volunteer_task_type_id IN (#{old_ids}) " +
        "AND volunteer_tasks.community_service_type_id IS NULL; "

      VolunteerTask.connection.execute(sql)

      # destroy community service and it's children
      service_types.each {|st| st.destroy}
      cs.destroy
    end

    change_column :volunteer_tasks, :duration, :float, :limit => 5, :default => nil, :null => true
    drop_table :volunteer_task_types_volunteer_tasks
    remove_column :volunteer_task_types, :required
  end


  def self.down
    add_column :volunteer_task_types, :required, :boolean, :default => true, :null => false
    VolunteerTask.connection.execute("CREATE TABLE volunteer_task_types_volunteer_tasks " +
                                     "(volunteer_task_id, volunteer_task_type_id)" +
                                     "AS SELECT id, volunteer_task_type_id FROM volunteer_tasks;")
    add_foreign_key( :volunteer_task_types_volunteer_tasks, ["volunteer_task_type_id"],
                     "volunteer_task_types", ["id"], :on_delete => :set_null )
    add_foreign_key( :volunteer_task_types_volunteer_tasks, ["volunteer_task_id"],
                     "volunteer_tasks", ["id"], :on_delete => :set_null )
    add_index :volunteer_task_types_volunteer_tasks, :volunteer_task_id
    change_column :volunteer_tasks, :duration, :decimal, :precision => 5, :scale => 2, :default => 0.0, :null => false

    service_types = CommunityServiceType.find(:all)
    unless service_types.empty?
      cs = VolunteerTaskType.create(:description => 'community service',
                                    :parent_id => 0, :hours_multiplier => 1,
                                    :instantiable => false, :required => false)
      new_service_types = {}
      for cst in service_types
        new_service_types[cst] = VolunteerTaskType.create(:description => cst.description,
                                                          :parent_id => cs.id,
                                                          :hours_multiplier => cst.hours_multiplier,
                                                          :instantiable => 't')
      end

      for vt in VolunteerTask.find(:all, :conditions => ["community_service_type_id IS NOT Null"])
        VolunteerTask.connection.execute("INSERT INTO volunteer_task_types_volunteer_tasks " +
                                         "(volunteer_task_type_id, volunteer_task_id) VALUES " +
                                         "(%d, %d)" % [new_service_types[vt.community_service_type].id, vt.id])
      end
    end

    remove_column :volunteer_tasks, :community_service_type_id
    remove_column :volunteer_tasks, :volunteer_task_type_id
    drop_table :community_service_types
  end
end
