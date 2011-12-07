class ViewVolunteerSchedule < ActiveRecord::Migration
  def self.up
    p = Privilege.new(:name => "view_volunteer_schedule")
    p.save!
    r = Role.new(:name => "VIEW_VOLUNTEER_SCHEDULE")
    r.privileges = [p]
    r.save!
  end

  def self.down
  end
end
