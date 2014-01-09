require 'test_helper'

class PunchEntryTest < ActiveSupport::TestCase
  fixtures :contacts

  test "creating punch entries" do
    # Create a Punch Entry
    p = PunchEntry.new(contact: Contact.first)
    assert_not_nil p.in_time
    assert_not_nil p.contact
    assert         p.valid?
  end

  test "signing in" do
    p = PunchEntry.sign_in(Contact.first)
    assert_not_nil p
    p.save

    # Double sign in should return the first sign in if within 30 minutes
    ps = PunchEntry.sign_in(Contact.first)
    assert_not_nil p
    assert_equal p, ps

    # Double sign in closes old one for review if longer than 30 minutes
    p.in_time = Time.zone.now - 40.minutes
    p.save
    ps = PunchEntry.sign_in(Contact.first)
    p.reload
    assert_not_equal p, ps, 'Returns new record when longer than 30 minutes'
    assert_equal p.duration, 0, "No credit for auto-sign out"
    assert p.flagged, 'old record is flagged'
    assert p.notations.size > 0, "A notation is present on the old entry"
  end

  test "flagged entries do not count for credit" do
    p = PunchEntry.new(contact: Contact.first,
                       station: VolunteerTaskType.first.id)
    p.in_time = Time.zone.now - 45.minutes
    p.out_time = Time.zone.now
    p.save

    assert_equal p.duration, 0.75, 'Expected duration for non-flagged'
    assert_not_nil p.volunteer_task, 'entry has a VolunteerTask'

    p.flagged = true
    assert_equal p.duration, 0

    # Check the volunteer task is updated
    vtid = p.volunteer_task.id
    p.save
    assert_equal p.duration, 0, 'No credit for flagged entry'
    assert_nil   p.volunteer_task , 'No associated volunteer task'
    assert_raises ActiveRecord::RecordNotFound do
      VolunteerTask.find(vtid)
    end
  end

  test "updating punch entries" do
    p = PunchEntry.new(contact: Contact.first)

    p.out_time =  p.in_time
    assert p.save, "A zero duration entry works"
    assert_equal p.duration, 0

    p.in_time = p.out_time - 900
    p.station = VolunteerTaskType.first
    assert p.save, "A 15 minute duration works"
    assert_equal p.duration, 0.25
    assert_not_nil p.volunteer_task

    p.out_time =  p.in_time
    assert p.save, "Reverting to a zero duration entry works"
    assert_equal p.duration, 0
    assert_nil p.volunteer_task
  end

  test "it rounds credit to 15 minutes" do
    t = Time.zone.now
    p = PunchEntry.new(contact: Contact.first)
    p.in_time = t - 3000
    p.out_time = p.in_time + 449 # Add just under 7 1/2 minutes
    assert_equal p.duration, 0

    p.out_time = p.in_time + 450
    assert_equal p.duration, 0.25

    p.out_time = p.in_time + 1349
    assert_equal p.duration, 0.25

    p.out_time = p.in_time + 1350
    assert_equal p.duration, 0.5
  end
end
