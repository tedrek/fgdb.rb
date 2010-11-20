weekdays = [2,3,4,5,6]
desc_n_slots = [[26, 4],[29, 4],[28, 2]]
time_ranges = [[11,15],[15,19]]

VolunteerDefaultShift.destroy_all

weekdays.each{|weekday_id|
  time_ranges.each{|start_time, end_time|
    desc_n_slots.each{|volunteer_task_type_id, slot_count|
      start_time = Time.parse(start_time.to_s + ":00")
      end_time = Time.parse(end_time.to_s + ":00")
      vds = VolunteerDefaultShift.new
      vds.effective_at = nil
      vds.ineffective_at = nil
      vds.weekday_id = weekday_id
      vds.start_time = start_time
      vds.end_time = end_time
      vds.slot_count = slot_count
      vds.volunteer_task_type_id = volunteer_task_type_id
      vds.roster_id = 1 # TODO
      vds.save!
    }
  }
}

VolunteerDefaultShift.generate(Date.today, Date.today + 7)
