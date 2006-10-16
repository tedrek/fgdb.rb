require File.dirname(__FILE__) + '/../test_helper'
require 'gizmo_detail_list'

class GizmoDetailListTest < Test::Unit::TestCase
  #fixtures :gizmo_detail_list
  fixtures  :gizmo_types

	NEW_GIZMO_DETAIL_LIST = {}	# e.g. {:name => 'Test GizmoDetailList', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = gizmo_detail_list(:first)
  end

  def test_raw_validation
    gizmo_detail_list = GizmoDetailList.new
    if REQ_ATTR_NAMES.blank?
      assert gizmo_detail_list.valid?, "GizmoDetailList should be valid without initialisation parameters"
    else
      # If GizmoDetailList has validation, then use the following:
      assert !gizmo_detail_list.valid?, "GizmoDetailList should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert gizmo_detail_list.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    gizmo_detail_list = GizmoDetailList.new #(NEW_GIZMO_DETAIL_LIST)
    assert_instance_of(GizmoDetailList, gizmo_detail_list,
      "instance has incorrect class (should be GizmoDetailList)")
    assert_equal({}, gizmo_detail_list.gizmo_list,
      "initial gizmo_list attr value should be empty hash")
 	end

  def test_add
    gdl = GizmoDetailList.new
    assert_nothing_raised()     {gdl.add(2,2)}
    assert_equal(1, gdl.gizmo_list.size,
      "Count of items in gizmo_list s/b 1")
    assert_equal(2, gdl.total('quantity'), "Total Quantity s/b 2")
    assert_raise(RuntimeError)  {gdl.add(99)}
  end

  def test_remove
    gdl = GizmoDetailList.new
    assert_nothing_raised()     {gdl.add(2,2)}
    assert_equal(1, gdl.gizmo_list.size,
      "Count of items in gizmo_list s/b 1")
    assert_nothing_raised()     {gdl.remove(2)}
    assert_equal(0, gdl.gizmo_list.size,
      "Count of items in gizmo_list s/b 0")
  end
end
