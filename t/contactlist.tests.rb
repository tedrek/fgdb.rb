#!/usr/bin/ruby -w
#
#   contactlist api tests
#

class ContactListTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::ContactList

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
		contact = FGDB::Contact.new
		list = FGDB::ContactList.new
		assert_respond_to( contact, :lists )
		assert_respond_to( list, :addContact )
		assert_respond_to( list, :removeContact )
		assert_respond_to( list, :contacts )
		assert_nothing_raised { list.addContact( contact ) }
		assert( contact.lists.include?( list ) )
		assert( list.contacts.include?( contact ) )
		assert_nothing_raised { list.removeContact( contact ) }
		assert( ! contact.lists.include?( list ) )
		assert( ! list.contacts.include?( contact ) )

	end

    def test_020_permissions

        contact = FGDB::Contact.new
        list = FGDB::ContactList.new
        assert_respond_to( list, :grant )
        assert_respond_to( list, :revoke )
        assert_respond_to( list, :rights )
        
        
        list.revoke( 'Login' )
        perform = nil
        assert_nothing_raised { perform = contact.perform?( act ) }
        assert( !perform )

        assert_raises( Exception ) { contact.perform( act ) }

    end

end # class ContactListTests
