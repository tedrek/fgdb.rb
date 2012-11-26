class AddSandboxToVolskedj < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      s = Sked.new
      s.name = "Sandbox"
      s.save!

      r = Roster.new
      r.name = "Sandbox"
      r.skeds << s
      r.save!

      vtt = VolunteerTaskType.find_by_name('slacking')
      for w in Weekday.find_all_by_is_open(true)
        ve = VolunteerDefaultEvent.new
        ve.description = "Sandbox Events"
        ve.weekday_id = w.id
        ve.notes = "This event is for testing purposes and will not affect the actual volunteer schedule."
        vs = VolunteerDefaultShift.new
        vs.start_time = Time.parse("12:00")
        vs.end_time = Time.parse("16:00")
        vs.slot_count = 4
        vs.volunteer_task_type_id = vtt.id
        vs.roster_id = r.id
        ve.volunteer_default_shifts << vs
        ve.save!
      end

      c = Conditions.new
      c.apply_conditions({})
      c.roster_enabled = true
      c.roster_id = r.id
      VolunteerDefaultShift.generate(Date.today, Date.today + 30, c)
    end
  end

  def self.down
    if Default.is_pdx
      Roster.find_by_name("Sandbox").destroy
      Sked.find_by_name("Sandbox").destroy
    end
  end
end
