class FixPastClassCredit < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      r = Roster.find_or_create_by_name("Monthly Classes").id
      for i in ["volunteer_shifts", "volunteer_default_shifts"]
        DB.exec("UPDATE #{i} SET class_credit = 'f' WHERE roster_id = #{r};")
      end
    end
  end

  def self.down
  end
end
