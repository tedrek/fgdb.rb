require File.dirname(__FILE__) + '/../test_helper'

class GizmoEventTest < Test::Unit::TestCase
  fixtures :gizmo_types

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_events(:first)
  end

  def test_that_empty_events_are_mostly_empty
    ev = GizmoEvent.new
    assert ev.mostly_empty?
    ev.gizmo_count = 2
    assert ev.mostly_empty?
    ev.gizmo_type = GizmoType.find(1)
    assert ! ev.mostly_empty?
  end

  def test_that_adjusted_fees_take_precedence
    orig = 100
    gt = GizmoType.new({ :description => 'test', :required_fee => orig })
    gt.save
    ge = GizmoEvent.new({ :gizmo_context => GizmoContext.donation, :gizmo_count => 1, :gizmo_type => gt})
    assert_equal orig, ge.required_fee
    updated = 1
    assert_nothing_raised { ge.adjusted_fee = updated }
    assert_equal updated, ge.required_fee
  end

end

