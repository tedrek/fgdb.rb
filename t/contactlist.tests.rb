#!/usr/bin/ruby -w
#
#   contactlist api tests
#

class ContactListTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

	def test_010_initialization 
		assert_kind_of( Class, FGDB::ContactList )
		assert( FGDB::Object > FGDB::ContactList )
		test = nil
		assert_nothing_raised { test = FGDB::ContactList.new }
		assert_kind_of( FGDB::ContactList, test )
	end

	def test_020_basicfunctions
		contactlist = FGDB::ContactList.new
		assert_respond_to( contactlist, :attributes )
		attrs = nil
		assert_nothing_raised { attrs = contactlist.attributes }
		assert( attrs )
		assert( ! attrs.empty? )
		attrs.each {|attribute, value|
			assert_respond_to( contactlist, attribute )
			assert_respond_to( contactlist, attribute + "=" )
			assert_nothing_raised { contactlist.send( attribute + "=", 1 ) }
			test = nil
			assert_nothing_raised { test = contactlist.send( attribute ) }
			assert_equal( 1, test )
		}
	end

	@@validations = {
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

	def test_030_validation 
		list = FGDB::ContactList.new
		@@validations.each {|attribute, tests|
			succeeds, failures = *tests
			succeeds.each {|test|
				assert_nothing_raised { list.send(attribute + "=", test) }
			}
			failures.each {|test|
				assert_raises( FGDB::InvalidValueError ) { list.send(attribute + "=", test) }
			}
		}		
	end
end # class ContactListTests
