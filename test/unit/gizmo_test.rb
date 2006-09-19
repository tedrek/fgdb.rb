require File.dirname(__FILE__) + '/../test_helper'

class GizmoTest < Test::Unit::TestCase
  fixtures :class_trees, :gizmos, :components, :pointing_devices, :pointing_devices

  def test_hierarchy_instantiation
    class_trees = ClassTree.find( :all, :conditions => ['instantiable = ?', true] )
    for class_tree in class_trees do
      gizmo = nil
      assert_nothing_raised { eval "gizmo = #{class_tree.class_name}.new" }
      assert_kind_of Gizmo, gizmo
    end
  end

  def test_database_hierarchy
    assert_kind_of Gizmo, gizmos( :cell_phone_001 )
    assert_kind_of CellPhone, gizmos( :cell_phone_001 )
    assert_kind_of Gizmo, gizmos( :pointing_device_001 )
    assert_kind_of Component, gizmos( :pointing_device_001 )
    assert_kind_of Drive, gizmos( :pointing_device_001 )
    assert_kind_of CdDrive, gizmos( :pointing_device_001 )
  end
end
