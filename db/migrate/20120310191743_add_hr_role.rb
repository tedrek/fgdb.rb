class AddHrRole < ActiveRecord::Migration
  def self.up
    Default["staff_hours_timeout"] = "5.minutes.ago"
    p = Privilege.new(:name => "log_all_workers_hours")
    p.save!
    r = Role.new(:name => "HR")
    r.privileges = [p]
    r.save!
  end

  def self.down
  end
end
