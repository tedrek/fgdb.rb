require 'test_helper'

class VolunteerEventTest < ActiveSupport::TestCase
  def test_factory
    event = FactoryGirl.build_stubbed(:volunteer_event)
    assert_not_nil event
    assert event.valid?
  end
end
