require File.dirname(__FILE__) + '/../test_helper'

class GizmoAttrTest < Test::Unit::TestCase
  fixtures :gizmo_attrs

	NEW_GIZMO_ATTR = {}	# e.g. {:name => 'Test GizmoAttr', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_attrs(:first)
  end

  def test_raw_validation
    gizmo_attr = GizmoAttr.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_attr.valid?, "GizmoAttr should be valid without initialisation parameters"
    else
      # If GizmoAttr has validation, then use the following:
      assert !gizmo_attr.valid?, "GizmoAttr should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_attr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_attr = GizmoAttr.new(NEW_GIZMO_ATTR)
    assert gizmo_attr.valid?, "GizmoAttr should be valid"
   	NEW_GIZMO_ATTR.each do |attr_name|
      assert_equal NEW_GIZMO_ATTR[attr_name], gizmo_attr.attributes[attr_name], "GizmoAttr.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_gizmo_attr = NEW_GIZMO_ATTR.clone
			tmp_gizmo_attr.delete attr_name.to_sym
			gizmo_attr = GizmoAttr.new(tmp_gizmo_attr)
			assert !gizmo_attr.valid?, "GizmoAttr should be invalid, as @#{attr_name} is invalid"
    	assert gizmo_attr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_gizmo_attr = GizmoAttr.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_attr = GizmoAttr.new(NEW_GIZMO_ATTR.merge(attr_name.to_sym => current_gizmo_attr[attr_name]))
			assert !gizmo_attr.valid?, "GizmoAttr should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_attr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

