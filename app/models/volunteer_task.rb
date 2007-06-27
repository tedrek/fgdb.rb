

class VolunteerTask < ActiveRecord::Base
  has_and_belongs_to_many :volunteer_task_types
  belongs_to  :contact, :order => "surname, first_name"

  validates_presence_of :date_performed
  validates_presence_of :contact_id
  validates_presence_of :duration

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
end
