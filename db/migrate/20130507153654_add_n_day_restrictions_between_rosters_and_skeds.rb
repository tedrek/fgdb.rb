class AddNDayRestrictionsBetweenRostersAndSkeds < ActiveRecord::Migration
  def self.up
    add_column :rosters, :restrict_to_every_n_days, :integer
    add_column :rosters, :restrict_from_sked_id, :integer
    add_foreign_key :rosters, :restrict_from_sked_id, :skeds, :id, :on_delete => :restrict

    if Default.is_pdx
      r = Roster.find_by_name("System Evaluation")
      if r
        r.restrict_from_sked = Sked.find_by_name_and_category_type("Prebuild", "Area")
        r.restrict_to_every_n_days = 7
        r.save!
      else
        puts "Warning: couldn't find syseval roster in pdx mode"
      end
    end
  end

  def self.down
  end
end
