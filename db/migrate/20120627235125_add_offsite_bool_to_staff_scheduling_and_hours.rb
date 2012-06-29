class AddOffsiteBoolToStaffSchedulingAndHours < ActiveRecord::Migration
  def self.up
    add_column :jobs, :offsite, :boolean, :null => false, :default => false
    add_column :work_shifts, :offsite, :boolean, :null => false, :default => false
    add_column :shifts, :offsite, :boolean, :null => false, :default => false
    add_column :worked_shifts, :offsite, :boolean

    Job.each do |x|
      if x.name.match(/off-?site/i)
        x.offsite = true
        x.save
      end
    end
  end

  def self.down
  end
end
