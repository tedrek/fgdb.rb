#!/usr/bin/ruby -w
#
#   superclass FGDB::Object api tests
#

class ObjectTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

	def test_010_initialization 
		assert_kind_of( Class, FGDB::Object )
		test = nil
		assert_nothing_raised { test = FGDB::Object.new }
		assert_kind_of( FGDB::Object, test )
	end

	def test_020_add_attributes
		subclass = Class::new(FGDB::Object)
		instance = subclass.new
		attrs = %w[ foo bar ]
		assert_nothing_raised { subclass.add_attributes( *attrs ) }
		assert_respond_to( subclass, :attributes )
		assert_respond_to( instance, :attributes )
		attrs = nil
		assert_nothing_raised { attrs = instance.attributes }
		assert( attrs )
		assert( ! attrs.empty? )
		meow = "meow"
		attrs.each {|attribute|
			assert_respond_to( instance, attribute )
			assert_respond_to( instance, attribute + "=" )
			assert( subclass.attributes.include?( attribute ) )
			assert( instance.attributes.include?( attribute ) )
			assert_nothing_raised { instance.send( attribute + "=", meow ) }
			test = nil
			assert_nothing_raised { test = instance.send( attribute ) }
			assert_equal( meow, test )
		}
	end

end # end class ObjectTests
