require File.dirname(__FILE__) + '/../test_helper'

class GizmoTypeattrTest < Test::Unit::TestCase
  fixtures :gizmo_typeattrs

	NEW_GIZMO_TYPEATTR = {}	# e.g. {:name => 'Test GizmoTypeattr', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_typeattrs(:first)
  end

  def test_raw_validation
    gizmo_typeattr = GizmoTypeattr.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_typeattr.valid?, "GizmoTypeattr should be valid without initialisation parameters"
    else
      # If GizmoTypeattr has validation, then use the following:
      assert !gizmo_typeattr.valid?, "GizmoTypeattr should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_typeattr = GizmoTypeattr.new(NEW_GIZMO_TYPEATTR)
    assert gizmo_typeattr.valid?, "GizmoTypeattr should be valid"
   	NEW_GIZMO_TYPEATTR.each do |attr_name|
      assert_equal NEW_GIZMO_TYPEATTR[attr_name], gizmo_typeattr.attributes[attr_name], "GizmoTypeattr.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_gizmo_typeattr = NEW_GIZMO_TYPEATTR.clone
			tmp_gizmo_typeattr.delete attr_name.to_sym
			gizmo_typeattr = GizmoTypeattr.new(tmp_gizmo_typeattr)
			assert !gizmo_typeattr.valid?, "GizmoTypeattr should be invalid, as @#{attr_name} is invalid"
    	assert gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_gizmo_typeattr = GizmoTypeattr.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_typeattr = GizmoTypeattr.new(NEW_GIZMO_TYPEATTR.merge(attr_name.to_sym => current_gizmo_typeattr[attr_name]))
			assert !gizmo_typeattr.valid?, "GizmoTypeattr should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

