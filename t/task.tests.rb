#!/usr/bin/ruby -w
#
#   task api tests
#

class TaskTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

	def test_010_initialization 
		assert_kind_of( Class, FGDB::Task )
		assert( FGDB::Object > FGDB::Task )
		test = nil
		assert_nothing_raised { test = FGDB::Task.new }
		assert_kind_of( FGDB::Task, test )
	end

	def test_020_basicfunctions
		task = FGDB::Task.new
	end
		
end
