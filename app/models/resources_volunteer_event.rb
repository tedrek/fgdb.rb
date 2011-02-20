class ResourcesVolunteerEvent < ActiveRecord::Base
  belongs_to :resource
  belongs_to :volunteer_event
  belongs_to :resources_volunteer_default_event

  def start_time(format = "%H:%M")
    read_attribute(:start_time).strftime(format)
  end

  def start_time=(str)
    write_attribute(:start_time, VolunteerShift._parse_time(str))
  end

  def end_time(format = "%H:%M")
    read_attribute(:end_time).strftime(format)
  end

  def end_time=(str)
    write_attribute(:end_time, VolunteerShift._parse_time(str))
  end
end
