#!/usr/bin/ruby -w
#
#   contact api tests
#

class ContactTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

	def test_010_initialization 
		assert_kind_of( Class, FGDB::Contact )
		test = nil
		assert_nothing_raised { test = FGDB::Contact.new() }
		assert_kind_of( FGDB::Contact, test )
	end

	def test_020_simple_attributes 
		contact = FGDB::Contact.new()
		assert_respond_to( contact, :attributes )
		attrs = nil
		assert_nothing_raised { attrs = contact.attributes }
		assert( attrs )
		assert( ! attrs.empty? )
		attrs.each {|attribute, value|
			assert_respond_to( contact, attribute )
			assert_respond_to( contact, attribute + "=" )
			assert_nothing_raised { contact.send( attribute + "=", "foo" ) }
			test = nil
			assert_nothing_raised { test = contact.send( attribute ) }
			assert( test == "foo" )
		}
	end

	def test_030_lists 
		contact = FGDB::Contact.new()
		list = FGDB::ContactList.new()
		assert_respond_to( contact, :lists )
		assert_respond_to( list, :addContact )
		assert_respond_to( list, :contacts )
		assert_nothing_raised { list.addContact( contact ) }
		assert( contact.lists.include?( list ) )
		assert( list.contacts.include?( contact ) )
	end

end # class ContactTests
