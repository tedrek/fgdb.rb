class VolunteerTask < ActiveRecord::Base
  acts_as_userstamp

  belongs_to :volunteer_task_type
  belongs_to :contact, :order => "surname, first_name"
  belongs_to :community_service_type

  validates_presence_of :contact
  validates_presence_of :volunteer_task_type
  validates_presence_of :date_performed
  validates_presence_of :duration

  before_save :add_contact_types

  def validate
    if contact.nil?
      errors.add(:contact_id, "must be choosen")
    end
    if duration.to_f <= 0.0
      errors.add(:duration, "must be greater than zero")
    end
  end

  def effective_duration
    duration * volunteer_task_type.hours_multiplier
  end

  def type_of_task?(type)
    volunteer_task_type.type_of_task? type
  end

  def add_contact_types
    # automatically make the person who did this a volunteer
    # the following is commented out because only
    # volunteers can be searched for... but non-volunteers
    # can become volunteers, can't they? See ticket #234
    required = [ContactType.volunteer] # volunteer
    if type_of_task?('build')
      required << ContactType.build # builder
    elsif type_of_task?('adoption')
      required << ContactType.adopter # adopter
    end
    for type in required
      unless contact.contact_types.include?(type)
        contact.contact_types << type
      end
    end
  end
end
