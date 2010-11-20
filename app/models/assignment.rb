class Assignment < ActiveRecord::Base
  belongs_to :volunteer_shift
  has_one :volunteer_task_type, :through => :volunteer_shift, :source => :volunteer_task_type
  belongs_to :contact

  after_destroy { |record| VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available }
  after_save { |record| VolunteerShift.find_by_id(record.volunteer_shift_id).fill_in_available }

  def display_name
    if contact_id.nil?
      return "(available)"
    else
      return self.contact.display_name
    end
  end

  def skedj_style(overlap, last)
    if overlap
      return 'hardconflict'
    end
    if self.end_time > self.volunteer_shift.end_time or self.start_time < self.volunteer_shift.start_time
      return 'mediumconflict'
    end
    if self.contact_id.nil?
      return 'available'
    else
      return 'shift'
    end
  end
end
