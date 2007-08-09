

class VolunteerTask < ActiveRecord::Base
  has_and_belongs_to_many :volunteer_task_types
  belongs_to  :contact, :order => "surname, first_name"

  validates_presence_of :date_performed
  validates_presence_of :contact_id
  validates_presence_of :duration

  before_save :add_contact_types

  def effective_duration
    mult = volunteer_task_types.inject(1) do |mu,type|
      mu *= type.hours_multiplier
    end
    duration * mult
  end

  def type_of_task?(type)
    volunteer_task_types.detect {|task_type|
      task_type.type_of_task?( type )
    }
  end

  def add_contact_types
    # automatically make the person who did this a volunteer
    # the following is commented out because only
    # volunteers can be searched for... but non-volunteers
    # can become volunteers, can't they? See ticket #234
    # required = [ContactType.find(4)] # volunteer
    if type_of_task?('build')
      required = ContactType.find(13) # builder
    elsif type_of_task?('adoption')
      required = ContactType.find(12) # adopter
    end
    if required and not contact.contact_types.include? required
      contact.contact_types << required
    end
  end
end
