require File.dirname(__FILE__) + '/../test_helper'

class RecyclingTest < ActiveSupport::TestCase
  #fixtures :recyclings, :gizmo_contexts, :gizmo_types
  load_all_fixtures

  def test_that_gizmo_events_occurred_when_recycled
    recycling = Recycling.new
    yesterday = Date.today - 1
    # Set the user stamps explicitly as there is no session in
    # a unit test
    recycling.created_by = User.find(1)
    recycling.updated_by = User.find(1)
    recycling.recycled_at = yesterday
    recycling.gizmo_events = [GizmoEvent.new(recycled_system_event)]
    assert recycling.save
    recycling = Recycling.find(recycling.id)
    event = recycling.gizmo_events[0]
    assert_equal recycling.recycled_at, event.occurred_at
    assert_not_equal event.created_at, event.occurred_at
  end
end
