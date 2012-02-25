class CreateContactVolunteerTaskTypeCounts < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false

    create_table :contact_volunteer_task_type_counts do |t|
      t.integer :contact_id
      t.integer :volunteer_task_type_id
      t.integer :count

      t.timestamps
    end

    DB.execute("SELECT DISTINCT contact_id, volunteer_task_type_id FROM volunteer_tasks WHERE volunteer_task_type_id IS NOT NULL and contact_id IS NOT NULL;").to_a.each{|h|
      cid = h["contact_id"]
      vttid = h["volunteer_task_type_id"]
      c = Contact.find(cid)
      c.update_syseval_count(vttid)
    }

    remove_column :contacts, :syseval_count
  end

  def self.down
    drop_table :contact_volunteer_task_type_counts
  end
end
