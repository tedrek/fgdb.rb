class AddContactTypeNeededToRosters < ActiveRecord::Migration
  def self.up
    add_column :rosters, :contact_type_id, :integer
    add_foreign_key :rosters, :contact_type_id, :contact_types, :id, :on_delete => :set_null
    if Default.is_pdx
      ct = ContactType.find_by_name("completed_system_eval")
      for i in ["Build Workshops", "Spanish Build"]
        r = Roster.find_by_name(i)
        r.contact_type = ct
        r.save!
      end
      ct = ContactType.find_by_name("completed_hardware_id")
      r = Roster.find_by_name("System Evaluation")
      r.contact_type = ct
      r.save!
    end
  end

  def self.down
  end
end
