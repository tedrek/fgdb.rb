require 'ajax_scaffold'

class VolunteerTask < ActiveRecord::Base
  has_and_belongs_to_many :volunteer_task_types
  belongs_to  :contact, :order => "surname, first_name"

  validates_presence_of :date_performed
  validates_presence_of :contact_id

  def effective_duration
    #:MC: work this in
    #   SELECT vt.id, vt.duration, vtt.hours_multiplier, vt.date_performed
    #     from volunteer_tasks as vt
    #     left join volunteer_task_types_volunteer_tasks as vttvt
    #       on vt.id = vttvt.volunteer_task_id
    #     left join volunteer_task_types as vtt
    #       on vtt.id = vttvt.volunteer_task_type_id
    #     where contact_id = 5729 and
    #       date_performed >= 'one year ago'
    #     order by vt.id;
    mult = volunteer_task_types.inject(1) do |mu,type|
      mu *= type.hours_multiplier
    end
    duration * mult
  end
  
end
