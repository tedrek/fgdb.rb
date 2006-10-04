require File.dirname(__FILE__) + '/../test_helper'

class GizmoActionTest < Test::Unit::TestCase
  fixtures :gizmo_actions

	NEW_GIZMO_ACTION = {}	# e.g. {:name => 'Test GizmoAction', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_actions(:first)
  end

  def test_raw_validation
    gizmo_action = GizmoAction.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_action.valid?, "GizmoAction should be valid without initialisation parameters"
    else
      # If GizmoAction has validation, then use the following:
      assert !gizmo_action.valid?, "GizmoAction should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_action.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_action = GizmoAction.new(NEW_GIZMO_ACTION)
    assert gizmo_action.valid?, "GizmoAction should be valid"
   	NEW_GIZMO_ACTION.each do |attr_name|
      assert_equal NEW_GIZMO_ACTION[attr_name], gizmo_action.attributes[attr_name], "GizmoAction.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_gizmo_action = NEW_GIZMO_ACTION.clone
			tmp_gizmo_action.delete attr_name.to_sym
			gizmo_action = GizmoAction.new(tmp_gizmo_action)
			assert !gizmo_action.valid?, "GizmoAction should be invalid, as @#{attr_name} is invalid"
    	assert gizmo_action.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_gizmo_action = GizmoAction.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_action = GizmoAction.new(NEW_GIZMO_ACTION.merge(attr_name.to_sym => current_gizmo_action[attr_name]))
			assert !gizmo_action.valid?, "GizmoAction should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_action.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

