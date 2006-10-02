require 'ajax_scaffold'

class VolunteerTask < ActiveRecord::Base
  has_and_belongs_to_many :volunteer_task_types
  belongs_to  :contact, :order => "surname, first_name"
end
