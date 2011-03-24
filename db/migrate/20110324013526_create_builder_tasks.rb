class CreateBuilderTasks < ActiveRecord::Migration
  def self.up
    create_table :builder_tasks do |t|
      t.integer :cashier_signed_off_by
      t.integer :action_id, :null => false
      t.integer :contact_id, :null => false
      t.text :notes

      t.timestamps
    end

    add_foreign_key :builder_tasks, :cashier_signed_off_by, :users, :id, :on_delete => :restrict
    add_foreign_key :builder_tasks, :action_id, :actions, :id
    add_foreign_key :builder_tasks, :contact_id, :contacts, :id

    add_column :spec_sheets, :builder_task_id, :integer
    add_foreign_key :spec_sheets, :builder_task_id, :builder_tasks, :id

    SpecSheet.find(:all).each{|ss|
      bt = ss.builder_task
      bt.notes = ss.read_attribute(:notes)
      bt.cashier_signed_off_by = ss.read_attribute(:cashier_signed_off_by)
      bt.action_id = ss.read_attribute(:action_id)
      bt.contact_id = ss.read_attribute(:contact_id)
      bt.save!
      ss.save!
    }

    change_column :spec_sheets, :builder_task_id, :integer, :null => false

    DB.exec("UPDATE builder_tasks SET created_at = spec_sheets.created_at FROM spec_sheets WHERE spec_sheets.builder_task_id = builder_tasks.id;")

    remove_column :spec_sheets, :cashier_signed_off_by
    remove_column :spec_sheets, :action_id
    remove_column :spec_sheets, :contact_id
    remove_column :spec_sheets, :notes
  end

  def self.down
    drop_table :builder_tasks
  end
end
