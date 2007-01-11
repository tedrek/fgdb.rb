require File.dirname(__FILE__) + '/../test_helper'

class GizmoEventTest < Test::Unit::TestCase
  fixtures :gizmo_events

	NEW_GIZMO_EVENT = {:gizmo_count => 2, :gizmo_type_id => 1, :gizmo_context_id => 1}	# e.g. {:name => 'Test GizmoEvent', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( gizmo_count gizmo_type_id gizmo_context_id) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_events(:first)
  end

  def test_raw_validation
    gizmo_event = GizmoEvent.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_event.valid?, "GizmoEvent should be valid without initialisation parameters"
    else
      # If GizmoEvent has validation, then use the following:
      assert !gizmo_event.valid?, "GizmoEvent should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_event.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_event = GizmoEvent.new(NEW_GIZMO_EVENT)
    assert gizmo_event.valid?, "GizmoEvent should be valid"
   	NEW_GIZMO_EVENT.each do |attr_name|
      assert_equal NEW_GIZMO_EVENT[attr_name], gizmo_event.attributes[attr_name], "GizmoEvent.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_gizmo_event = NEW_GIZMO_EVENT.clone
			tmp_gizmo_event.delete attr_name.to_sym
			gizmo_event = GizmoEvent.new(tmp_gizmo_event)
			assert !gizmo_event.valid?, "GizmoEvent should be invalid, as @#{attr_name} is invalid"
    	assert gizmo_event.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_gizmo_event = GizmoEvent.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_event = GizmoEvent.new(NEW_GIZMO_EVENT.merge(attr_name.to_sym => current_gizmo_event[attr_name]))
			assert !gizmo_event.valid?, "GizmoEvent should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_event.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

