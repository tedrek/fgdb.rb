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
		assert_kind_of( FGDB::Object, FGDB::Contact )
		test = nil
		assert_nothing_raised { test = FGDB::Contact.new() }
		assert_kind_of( FGDB::Contact, test )
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

	def test_040_tasks
		contact = FGDB::Contact.new()
		task = FGDB::Task.new()
		assert_respond_to( contact, :tasks )
		assert_respond_to( contact, :addTask )
		assert_respond_to( contact, :hours )
		assert_respond_to( task, :contact )	
	
		assert_nothing_raised { task.hours = 5 }
		assert( task.hours == 5 )
		assert_nothing_raised { contact.addTask( task ) }
		assert( contact.tasks.include?( task ) )
		assert( task.contact == contact )
		assert( contact.hours == 5 )

	end


end # class ContactTests
