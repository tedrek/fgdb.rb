weekdays = [2,3,4,5,6]
desc_n_slots = [[26, 4, "Build Workshop"],[29, 4, "Recycling"],[28, 2, "Receiving"]]
time_ranges = [[11,15],[15,19]]

VolunteerDefaultShift.destroy_all
VolunteerDefaultEvent.destroy_all

VolunteerShift.destroy_all
VolunteerEvent.destroy_all

weekdays.each{|weekday_id|
  time_ranges.each{|start_time, end_time|
    desc_n_slots.each{|volunteer_task_type_id, slot_count, foo|
      vde = VolunteerDefaultEvent.new
      vde.weekday_id = weekday_id
      vde.description = foo
      start_time = Time.parse(start_time.to_s + ":00")
      end_time = Time.parse(end_time.to_s + ":00")
      vds = VolunteerDefaultShift.new
      vds.volunteer_default_event = vde
      vds.effective_at = nil
      vds.ineffective_at = nil
      vds.start_time = start_time
      vds.end_time = end_time
      vds.slot_count = slot_count
      vds.volunteer_task_type_id = volunteer_task_type_id
      vds.roster_id = (volunteer_task_type_id == 26 ? 2 : 1)
      vds.save!
    }
  }
}

VolunteerDefaultShift.generate(Date.today, Date.today + 7)
