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

    new_service_types = {}
    service_types = VolunteerTaskType.find_all_by_parent_id(18)
    for vtt in service_types
      new_service_types[vtt] = CommunityServiceType.create({ :description => vtt.description,
                                                             :hours_multiplier => vtt.hours_multiplier })
    end

    # move many-to-many assoc. over to two one-to-many assocs.
    old_ids = service_types.map {|st| st.id.to_s}.join(',')
    sql = "CREATE TABLE temp_volunteer_tasks AS " +
      "SELECT vt.id, " +
      "CASE WHEN vttvt.volunteer_task_type_id IN (#{old_ids}) " +
      "THEN Null ELSE vttvt.volunteer_task_type_id END, " +
      "CASE "
    new_service_types.each {|old,new|
      sql += "WHEN vttvt.volunteer_task_type_id = %d THEN %d " % [old.id, new.id]
    }
    sql += "ELSE Null END"
    VolunteerTask.connection.execute(sql)

    sql = "UPDATE volunteer_tasks " +
      "JOIN volunteer_task_types_volunteer_tasks AS vttvt " +
      "ON volunteer_tasks.id = vttvt.volunteer_task_id SET " + ""


    # destroy community service and it's children
    service_types.each {|st| st.destroy}
    VolunteerTaskType.destroy(18)

    change_column :volunteer_tasks, :duration, :float, :limit => 5, :default => nil, :null => true
    drop_table :volunteer_task_types_volunteer_tasks
    remove_column :volunteer_task_types, :required
  end


  def self.down
    add_column :volunteer_task_types, :required, :boolean, :default => true, :null => false
    VolunteerTask.connection.execute("CREATE TABLE volunteer_task_types_volunteer_tasks " +
                                     "AS SELECT id, volunteer_task_id FROM volunteer_tasks;")
    add_foreign_key( :volunteer_task_types_volunteer_tasks, ["volunteer_task_type_id"],
                     "volunteer_task_types", ["id"], :on_delete => :set_null )
    add_foreign_key( :volunteer_task_types_volunteer_tasks, ["volunteer_task_id"],
                     "volunteer_tasks", ["id"], :on_delete => :set_null )
    add_index :volunteer_task_types_volunteer_tasks, :volunteer_task_id
    change_column :volunteer_tasks, :duration, :decimal, :precision => 5, :scale => 2, :default => 0.0, :null => false

    cs = VolunteerTaskType.create(:description => 'community service',
                                  :parent_id => 0, :hours_multiplier => 1,
                                  :instantiable => false, :required => false)

    service_types = CommunityServiceType.find(:all)
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


    remove_column :volunteer_tasks, :community_service_type_id
    remove_column :volunteer_tasks, :volunteer_task_type_id
    drop_table :community_service_types
  end
end
