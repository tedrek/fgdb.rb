class VolunteerTask < ActiveRecord::Base
  belongs_to :volunteer_task_type
  belongs_to :contact, :order => "surname, first_name"
  belongs_to :community_service_type

  validates_presence_of :start_time
  validates_presence_of :contact
  validates_presence_of :volunteer_task_type
  validates_presence_of :duration

  before_save :add_contact_types


  def validate
    unless duration.nil? or duration > 0
      errors.add(:end_time, "must be after you started")
    end
    # Don't try to calculate the end_time if there is no start_time
    unless start_time.nil?
      errors.add(:end_time, "must be some time before now") if end_time > Time.now
    end
    if contact.nil?
      errors.add(:contact_id, "must be choosen")
    else
      last_completed = contact.volunteer_tasks.find(:first, :order => "start_time + interval '1 hour' * duration DESC", :conditions => 'duration > 0')
    end
    if not last_completed.nil? and start_time < last_completed.end_time
      errors.add(:start_time, "must be some time after you finished volunteering this time")
    end
  end

  def effective_duration
    duration * volunteer_task_type.hours_multiplier
  end

  def type_of_task?(type)
    volunteer_task_type.type_of_task? type
  end

  def end_time
    unless duration.nil?
      start_time + duration.hours
    else
      Time.now
    end
  end

  def end_time=(t)
    self.duration = (t - start_time) / 1.hour
  end

  def add_contact_types
    # automatically make the person who did this a volunteer
    # the following is commented out because only
    # volunteers can be searched for... but non-volunteers
    # can become volunteers, can't they? See ticket #234
    required = [ContactType.find(4)] # volunteer
    if type_of_task?('build')
      required << ContactType.find(13) # builder
    elsif type_of_task?('adoption')
      required << ContactType.find(12) # adopter
    end
    for type in required
      unless contact.contact_types.include?(type)
        contact.contact_types << type
      end
    end
  end
end
