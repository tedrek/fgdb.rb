class AddCollectiveLevelRole < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      ActiveRecord::Base.record_timestamps = false
      r = Role.new(:name => "COLLECTIVE", :notes => "This role will give access to a report which summarizes worked staff hours.")
      p = Privilege.new(:name => 'staff_summary_report')
      p.save!
      r.privileges << p
      r.save!
      Worker.all.each do |w|
        if w.worker_type_today.name == 'collective' and w.contact and w.contact.user
          u = w.contact.user
          u.roles << r unless u.roles.include?(r)
          u.save!
        end
      end
    end
  end

  def self.down
    if Default.is_pdx
      ActiveRecord::Base.record_timestamps = false
      Role.find_by_name("COLLECTIVE").destroy
    end
  end
end
