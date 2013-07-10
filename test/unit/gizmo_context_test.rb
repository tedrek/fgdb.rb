require File.dirname(__FILE__) + '/../test_helper'

class GizmoContextTest < ActiveSupport::TestCase
  fixtures :gizmo_contexts

	NEW_GIZMO_CONTEXT = {}	# e.g. {:name => 'Test GizmoContext', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_contexts(:first)
  end

  def test_raw_validation
    gizmo_context = GizmoContext.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_context.valid?, "GizmoContext should be valid without initialisation parameters"
    else
      # If GizmoContext has validation, then use the following:
      assert !gizmo_context.valid?, "GizmoContext should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_context.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_context = GizmoContext.new(NEW_GIZMO_CONTEXT)
    assert gizmo_context.valid?, "GizmoContext should be valid"
   	NEW_GIZMO_CONTEXT.each do |attr_name|
      assert_equal NEW_GIZMO_CONTEXT[attr_name], gizmo_context.attributes[attr_name], "GizmoContext.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_gizmo_context = NEW_GIZMO_CONTEXT.clone
			tmp_gizmo_context.delete attr_name.to_sym
			gizmo_context = GizmoContext.new(tmp_gizmo_context)
			assert !gizmo_context.valid?, "GizmoContext should be invalid, as @#{attr_name} is invalid"
    	assert gizmo_context.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_gizmo_context = GizmoContext.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_context = GizmoContext.new(NEW_GIZMO_CONTEXT.merge(attr_name.to_sym => current_gizmo_context[attr_name]))
			assert !gizmo_context.valid?, "GizmoContext should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_context.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

