require File.dirname(__FILE__) + '/../test_helper'

class GizmoContextsGizmoTypeattrTest < Test::Unit::TestCase
  fixtures :gizmo_contexts_gizmo_typeattrs

	NEW_GIZMO_CONTEXTS_GIZMO_TYPEATTR = {}	# e.g. {:name => 'Test GizmoContextsGizmoTypeattr', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_contexts_gizmo_typeattrs(:first)
  end

  def test_raw_validation
    gizmo_contexts_gizmo_typeattr = GizmoContextsGizmoTypeattr.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_contexts_gizmo_typeattr.valid?, "GizmoContextsGizmoTypeattr should be valid without initialisation parameters"
    else
      # If GizmoContextsGizmoTypeattr has validation, then use the following:
      assert !gizmo_contexts_gizmo_typeattr.valid?, "GizmoContextsGizmoTypeattr should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_contexts_gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_contexts_gizmo_typeattr = GizmoContextsGizmoTypeattr.new(NEW_GIZMO_CONTEXTS_GIZMO_TYPEATTR)
    assert gizmo_contexts_gizmo_typeattr.valid?, "GizmoContextsGizmoTypeattr should be valid"
   	NEW_GIZMO_CONTEXTS_GIZMO_TYPEATTR.each do |attr_name|
      assert_equal NEW_GIZMO_CONTEXTS_GIZMO_TYPEATTR[attr_name], gizmo_contexts_gizmo_typeattr.attributes[attr_name], "GizmoContextsGizmoTypeattr.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_gizmo_contexts_gizmo_typeattr = NEW_GIZMO_CONTEXTS_GIZMO_TYPEATTR.clone
			tmp_gizmo_contexts_gizmo_typeattr.delete attr_name.to_sym
			gizmo_contexts_gizmo_typeattr = GizmoContextsGizmoTypeattr.new(tmp_gizmo_contexts_gizmo_typeattr)
			assert !gizmo_contexts_gizmo_typeattr.valid?, "GizmoContextsGizmoTypeattr should be invalid, as @#{attr_name} is invalid"
    	assert gizmo_contexts_gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_gizmo_contexts_gizmo_typeattr = GizmoContextsGizmoTypeattr.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		gizmo_contexts_gizmo_typeattr = GizmoContextsGizmoTypeattr.new(NEW_GIZMO_CONTEXTS_GIZMO_TYPEATTR.merge(attr_name.to_sym => current_gizmo_contexts_gizmo_typeattr[attr_name]))
			assert !gizmo_contexts_gizmo_typeattr.valid?, "GizmoContextsGizmoTypeattr should be invalid, as @#{attr_name} is a duplicate"
    	assert gizmo_contexts_gizmo_typeattr.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

