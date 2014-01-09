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
