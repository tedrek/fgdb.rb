require File.dirname(__FILE__) + '/../test_helper'

class GizmoEventsGizmoTypeattrTest < Test::Unit::TestCase
  fixtures :gizmo_events_gizmo_typeattrs, :gizmo_types, :gizmo_attrs, :gizmo_typeattrs, :gizmo_contexts

        NEW_GIZMO_EVENTS_GIZMO_TYPEATTR = {}    # e.g. {:name => 'Test GizmoEventsGizmoTypeattr', :description => 'Dummy'}
        REQ_ATTR_NAMES                   = %w( ) # name of fields that must be present, e.g. %(name description)
        DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  Test::Unit::TestCase.integer_math_test(self, "GizmoEventsGizmoTypeattr", "attr_val_monetary")

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_events_gizmo_typeattrs(:first)
  end

  def test_raw_validation
    gizmo_events_gizmo_typeattr = GizmoEventsGizmoTypeattr.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_events_gizmo_typeattr.valid?, "GizmoEventsGizmoTypeattr should be valid without initialisation parameters"
    else
      # If GizmoEventsGizmoTypeattr has validation, then use the following:
      assert !gizmo_events_gizmo_typeattr.valid?, "GizmoEventsGizmoTypeattr should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_events_gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

        def test_new
    gizmo_events_gizmo_typeattr = GizmoEventsGizmoTypeattr.new(NEW_GIZMO_EVENTS_GIZMO_TYPEATTR)
    assert gizmo_events_gizmo_typeattr.valid?, "GizmoEventsGizmoTypeattr should be valid"
        NEW_GIZMO_EVENTS_GIZMO_TYPEATTR.each do |attr_name|
      assert_equal NEW_GIZMO_EVENTS_GIZMO_TYPEATTR[attr_name], gizmo_events_gizmo_typeattr.attributes[attr_name], "GizmoEventsGizmoTypeattr.@#{attr_name.to_s} incorrect"
    end
        end

        def test_validates_presence_of
        REQ_ATTR_NAMES.each do |attr_name|
                        tmp_gizmo_events_gizmo_typeattr = NEW_GIZMO_EVENTS_GIZMO_TYPEATTR.clone
                        tmp_gizmo_events_gizmo_typeattr.delete attr_name.to_sym
                        gizmo_events_gizmo_typeattr = GizmoEventsGizmoTypeattr.new(tmp_gizmo_events_gizmo_typeattr)
                        assert !gizmo_events_gizmo_typeattr.valid?, "GizmoEventsGizmoTypeattr should be invalid, as @#{attr_name} is invalid"
        assert gizmo_events_gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
        end

        def test_duplicate
    current_gizmo_events_gizmo_typeattr = GizmoEventsGizmoTypeattr.find(:first)
        DUPLICATE_ATTR_NAMES.each do |attr_name|
                gizmo_events_gizmo_typeattr = GizmoEventsGizmoTypeattr.new(NEW_GIZMO_EVENTS_GIZMO_TYPEATTR.merge(attr_name.to_sym => current_gizmo_events_gizmo_typeattr[attr_name]))
                        assert !gizmo_events_gizmo_typeattr.valid?, "GizmoEventsGizmoTypeattr should be invalid, as @#{attr_name} is a duplicate"
        assert gizmo_events_gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
                end
        end

    def test_that_to_cents_works
      assert_equal 230, "2.3".to_cents
      assert_equal 240, "2.40".to_cents
      assert_equal 253, "2.53".to_cents
      assert_equal 281, "2.810002".to_cents
      assert_nothing_raised {"meow".to_cents}
      assert_equal 0, "meow".to_cents
    end

    def test_that_price_can_come_in_cents
      ge = GizmoEvent.new({:gizmo_type => GizmoType.find(:first), :gizmo_context => GizmoContext.sale})
      ge.unit_price = "3.23"
      assert_nothing_raised {ge.unit_price_cents}
      assert_equal 323, ge.unit_price_cents
    end

    def test_to_dollars
      assert_equal "10.00", 1000.to_dollars
      assert_equal "10.01", 1001.to_dollars
      assert_equal "10.20", 1020.to_dollars
      assert_equal "0.25",  25.to_dollars
    end

end

