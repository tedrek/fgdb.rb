#!/usr/bin/ruby -w
#
#   gizmolist api tests
#

class GizmoListTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::GizmoList

	self.validations = {

		"listname" => [ [
				"foo", "Builders", "short people", "#1's", "3D Modeling Group"
			],
					   [
				"a" * 1000, " " * 5, nil
			] ],

		"remarks" => [ [
				"this is a remark", "", nil, 
			],
					  [
				# no failing tests
			] ],

#		"" => [ [ ], [ ] ],
	}
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



end # class GizmoListTests
