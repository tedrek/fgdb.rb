require File.dirname(__FILE__) + '/../test_helper'

class GizmoAttrTypeTest < Test::Unit::TestCase
  fixtures :gizmo_attr_types

	NEW_GIZMO_ATTR_TYPE = {}	# e.g. {:name => 'Test GizmoAttrType', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_attr_types(:first)
  end

  def test_raw_validation
    gizmo_attr_type = GizmoAttrType.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_attr_type.valid?, "GizmoAttrType should be valid without initialisation parameters"
    else
      # If GizmoAttrType has validation, then use the following:
      assert !gizmo_attr_type.valid?, "GizmoAttrType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_attr_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_attr_type = GizmoAttrType.new(NEW_GIZMO_ATTR_TYPE)
    assert gizmo_attr_type.valid?, "GizmoAttrType should be valid"
   	NEW_GIZMO_ATTR_TYPE.each do |attr_name|
      assert_equal NEW_GIZMO_ATTR_TYPE[attr_name], gizmo_attr_type.attributes[attr_name], "GizmoAttrType.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_gizmo_attr_type = NEW_GIZMO_ATTR_TYPE.clone
			tmp_gizmo_attr_type.delete attr_name.to_sym
			gizmo_attr_type = GizmoAttrType.new(tmp_gizmo_attr_type)
			assert !gizmo_attr_type.valid?, "GizmoAttrType should be invalid, as @#{attr_name} is invalid"
    	assert gizmo_attr_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_gizmo_attr_type = GizmoAttrType.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_attr_type = GizmoAttrType.new(NEW_GIZMO_ATTR_TYPE.merge(attr_name.to_sym => current_gizmo_attr_type[attr_name]))
			assert !gizmo_attr_type.valid?, "GizmoAttrType should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_attr_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

