class AddLimitFieldToRosters < ActiveRecord::Migration
  def self.up
    add_column :rosters, :limit_shift_signup_by_program, :boolean, :default => false, :null => false
    if Default.is_pdx
      for i in ["Hardware ID", "System Evaluation", "Build Workshops", "Spanish Build", "Receiving", "Recycling", "Printerland", "Misc"]
        r = Roster.find_by_name(i)
        r.limit_shift_signup_by_program = true
        r.save!
      end
    end
  end

  def self.down
  end
end
