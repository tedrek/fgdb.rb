#!/usr/bin/ruby -w
#
#   gizmo api tests
#

class GizmoTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::Gizmo

	def test_010_lists 
		gizmo = FGDB::Gizmo.new
		list = FGDB::GizmoList.new
		assert_respond_to( gizmo, :lists )
		assert_respond_to( list, :addGizmo )
		assert_respond_to( list, :gizmos )
		assert_nothing_raised { list.addGizmo( gizmo ) }
		assert( gizmo.lists.include?( list ) )
		assert( list.gizmos.include?( gizmo ) )
	end

end # class GizmoTests
