#!/usr/bin/ruby -w
#
#   contact api tests
#

class ContactTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::Contact

	def test_010_lists 
		contact = FGDB::Contact.new
		list = FGDB::ContactList.new
		assert_respond_to( contact, :lists )
		assert_respond_to( list, :addContact )
		assert_respond_to( list, :contacts )
		assert_nothing_raised { list.addContact( contact ) }
		assert( contact.lists.include?( list ) )
		assert( list.contacts.include?( contact ) )
	end

	def test_020_tasks
		contact = FGDB::Contact.new
		task = FGDB::Task.new
		assert_respond_to( contact, :tasks )
		assert_respond_to( contact, :addTask )
		assert_respond_to( contact, :hours )
		assert_respond_to( task, :contact )	
	
		hours = 5
		assert_nothing_raised { task.hours = hours }
		assert_equal( 5, task.hours )
		assert_nothing_raised { contact.addTask( task ) }
		assert( contact.tasks.include?( task ) )
		assert_equal( contact, task.contact )
		assert_equal( hours, contact.hours )
	end


end # class ContactTests
