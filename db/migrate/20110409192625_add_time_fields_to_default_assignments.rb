class AddTimeFieldsToDefaultAssignments < ActiveRecord::Migration
  def self.up
    add_column :default_assignments, :start_time, :time
    add_column :default_assignments, :end_time, :time
    add_column :default_assignments, :slot_number, :integer
    DefaultAssignment.find(:all).each{|x|
      i = 1
      x.volunteer_default_shift.slot_count.times do
        x.start_time = x.volunteer_default_shift.start_time
        x.end_time = x.volunteer_default_shift.end_time
        x.slot_number = i
        x.save!
        i += 1
      end
    }
    VolunteerDefaultShift.find(:all).each{|x| x.fill_in_available}
    VolunteerDefaultEvent.find(:all).each{|x|
      x.merge_similar_shifts
    }
    VolunteerEvent.find(:all).each{|x|
      x.merge_similar_shifts
    }
  end

  def self.down
    remove_column :default_assignments, :start_time
    remove_column :default_assignments, :end_time
    remove_column :default_assignments, :slot_number
  end
end
