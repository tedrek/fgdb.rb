require File.dirname(__FILE__) + '/../test_helper'

class GizmoTypeTest < ActiveSupport::TestCase
  fixtures :gizmo_types

  NEW_GIZMO_TYPE = { }    # e.g. {:name => 'Test GizmoType', :description => 'Dummy'}
  REQ_ATTR_NAMES = %w() # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_types(:first)
  end

  def test_raw_validation
    gizmo_type = GizmoType.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_type.valid?, "GizmoType should be valid without initialisation parameters"
    else
      # If GizmoType has validation, then use the following:
      assert !gizmo_type.valid?, "GizmoType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_new
    gizmo_type = GizmoType.new(NEW_GIZMO_TYPE)
    assert gizmo_type.valid?, "GizmoType should be valid"
    NEW_GIZMO_TYPE.each do |attr_name|
      assert_equal NEW_GIZMO_TYPE[attr_name], gizmo_type.attributes[attr_name], "GizmoType.@#{attr_name.to_s} incorrect"
    end
  end

  def test_validates_presence_of
    REQ_ATTR_NAMES.each do |attr_name|
      tmp_gizmo_type = NEW_GIZMO_TYPE.clone
      tmp_gizmo_type.delete attr_name.to_sym
      gizmo_type = GizmoType.new(tmp_gizmo_type)
      assert !gizmo_type.valid?, "GizmoType should be invalid, as @#{attr_name} is invalid"
      assert gizmo_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_duplicate
    current_gizmo_type = GizmoType.find(:first)
    DUPLICATE_ATTR_NAMES.each do |attr_name|
      gizmo_type = GizmoType.new(NEW_GIZMO_TYPE.merge(attr_name.to_sym => current_gizmo_type[attr_name]))
      assert !gizmo_type.valid?, "GizmoType should be invalid, as @#{attr_name} is a duplicate"
      assert gizmo_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  Test::Unit::TestCase.integer_math_test(self, "GizmoType", "required_fee")
  Test::Unit::TestCase.integer_math_test(self, "GizmoType", "suggested_fee")
end

