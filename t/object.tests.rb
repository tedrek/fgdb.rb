#!/usr/bin/ruby -w
#
#   contact api tests
#

class ObjectTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

	def test_010_initialization 
		assert_kind_of( Class, FGDB::Object )
		test = nil
		assert_nothing_raised { test = FGDB::Object.new() }
		assert_kind_of( FGDB::Object, test )
	end

	def test_020_simple_attributes 
		object = FGDB::Object.new()
		assert_respond_to( object, :attributes )
		attrs = nil
		assert_nothing_raised { attrs = object.attributes }
		assert( attrs )
		assert( ! attrs.empty? )
		attrs.each {|attribute, value|
			assert_respond_to( object, attribute )
			assert_respond_to( object, attribute + "=" )
			assert_nothing_raised { object.send( attribute + "=", "foo" ) }
			test = nil
			assert_nothing_raised { test = object.send( attribute ) }
			assert( test == "foo" )
		}
	end

end # end class ObjectTests
