#!/usr/bin/ruby -w
#
#   contact api tests
#

class ContactTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::Contact

	# list testing moved to contactlist.tests.rb
	
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
