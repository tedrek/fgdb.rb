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
		assert_respond_to( task, :attributes )
		attrs = nil
		assert_nothing_raised { attrs = task.attributes }
		assert( attrs )
		assert( ! attrs.empty? )
		attrs.each {|attribute, value|
			assert_respond_to( task, attribute )
			assert_respond_to( task, attribute + "=" )
			assert_nothing_raised { task.send( attribute + "=", 1 ) }
			test = nil
			assert_nothing_raised { test = task.send( attribute ) }
			assert_equal( 1, test )
		}

		assert_raises( FGDB::InvalidValueError ) { task.hours = -1 }
	end
		
end
