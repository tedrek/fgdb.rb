require File.dirname(__FILE__) + '/../test_helper'

class GizmoEventsGizmoTypeattrTest < Test::Unit::TestCase
  fixtures :gizmo_events_gizmo_typeattrs

	NEW_GIZMO_EVENTS_GIZMO_TYPEATTR = {}	# e.g. {:name => 'Test GizmoEventsGizmoTypeattr', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

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
    current_gizmo_events_gizmo_typeattr = GizmoEventsGizmoTypeattr.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_events_gizmo_typeattr = GizmoEventsGizmoTypeattr.new(NEW_GIZMO_EVENTS_GIZMO_TYPEATTR.merge(attr_name.to_sym => current_gizmo_events_gizmo_typeattr[attr_name]))
			assert !gizmo_events_gizmo_typeattr.valid?, "GizmoEventsGizmoTypeattr should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_events_gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

