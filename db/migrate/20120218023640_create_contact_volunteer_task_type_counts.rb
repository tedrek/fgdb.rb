class CreateContactVolunteerTaskTypeCounts < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false

    # :joins - Either an SQL fragment for additional jOIN comments ON comments.post_id = id" (rarely
    # :select => "webpages.*, COUNT(webpage_hit.id) AS view_count",

    create_table :contact_volunteer_task_type_counts do |t|
      t.integer :contact_id
      t.integer :volunteer_task_type_id
      t.integer :count

      t.timestamps
    end

    DB.execute("SELECT DISTINCT contact_id, volunteer_task_type_id FROM volunteer_tasks WHERE volunteer_task_type_id IS NOT NULL;").to_a.each{|h|
      cid = h["contact_id"]
      vttid = h["volunteer_task_type_id"]
      c = Contact.find(cid)
      c.update_syseval_count(vttid)
    }

    # TODO:       remove_column :contacts, :
  end

  def self.down
    drop_table :contact_volunteer_task_type_counts
  end
end
