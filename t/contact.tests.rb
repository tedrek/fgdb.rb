#!/usr/bin/ruby -w
#
#   contact api tests
#

class ContactTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::Contact

	self.validations = {
		"firstname" => [ [
				"John", "J", "1", "", nil
			], [
				-1
			] ],
		"lastname" => [ [
				"John", "J", "1", "", nil
			], [
				0
			] ],
		"middlename" => [ [
				"John", "J", "1", "", nil
			], [
				-1
			] ],
		"address" => [ [
				"275 NW Glisan St", "500 Burnside St Apt 4", "", nil
			], [
				"275", -1
			] ],
		"address2" => [ [
				"Anything", "A", "1", "",  nil
			], [
				0
			] ],
		"city" => [ [
				"Portland", "PDX", "", nil
			], [
				-1, "1"
			] ],
	
		"state" => [ [
				"AL", "OR", "", nil
			], [
				"Alaska", "Oregon", "OZ", "O", "ORE", "Boogedy"
			] ],
	
		"zip" => [ [
				97202, "97202", "10440", "97202-4444", nil, ""
			], [
				-1, "1", 9720, 972021, "97202-444", "blah", "anything", "97", "972"
			] ],
	
		"phone" => [ [
				"503-333-4455", "503.444.4565", "5033365542", "15034561234", "18004562200", "415-554-5544 ext. 444", "752-4159", "7524159", 5034456699, nil, "", "503.5445599"
			], [
				"50-551-4455", "28004451122", "415-112-111", "911", "1", "515-51-5522", "111.111.1111"
			] ],
	
		"email" => [ [
				nil, "", "email@yahoo.com", "abuse@yahoo.com", "abuse@a.ca", "fabuloso@boring.tv", "foo@gmail.com", "zero at google dot com"
			], [
				"foo", "foogmailcom", 0, "1", "abuse@example.com"
			] ],
	}

	# list testing moved to contactlist.tests.rb
	
	def test_020_tasks
		contact = FGDB::Contact.new
		task = FGDB::Task.new

		assert_respond_to( contact, :tasks )
		assert_respond_to( contact, :addTask )
		assert_respond_to( contact, :removeTask )
		assert_respond_to( contact, :hours )
		assert_respond_to( task, :contact )	
	
		hours = 5
		assert_nothing_raised { task.hours = hours }
		assert_equal( 5, task.hours )
		assert_nothing_raised { contact.addTask( task ) }
		assert( contact.tasks.include?( task ) )
		assert_equal( contact, task.contact )
		assert_equal( hours, contact.hours )
		assert_nothing_raised { contact.removeTask( task ) }
		assert( ! contact.tasks.include?( task ) )
		assert_equal( nil, task.contact )
		assert_equal( 0, contact.hours )

	end
	def test_030_donttouch
		contact = FGDB::Contact.new
		assert_raises( NoMethodError ) { contact.modified = "hello" }
		assert_raises( NoMethodError ) { contact.sortName = "hello" }
		assert_raises( NoMethodError ) { contact.created = "hello" }
	end

    def test_040_actions
        contact = FGDB::Contact.new
        act = FGDB::Act.new( 'Login' )
        loginP = FGDB::Permission.new( 'Login' )
        logoutP = FGDB::Permission.new( 'Logout' )
        list = FGDB::ContactList.new
        
        list.grant( loginP )
        list.grant( logoutP )
        list.addContact( contact )
        
        assert_responds_to( contact, :perform? )
        assert_responds_to( contact, :perform )
        assert_responds_to( contact, :acts )
        assert_responds_to( contact, :loggedIn? )
        
        perform = nil
        assert_nothing_raised { perform = contact.perform?( act ) }
        assert( perform )
        
        assert_nothing_raised { contact.perform( act ) }
 
        acts = nil
        assert_nothing_raised { acts = contact.acts }
        assert( acts.include?( act ) )
        assert( act.contact == contact )
        
        assert( contact.loggedIn? )
        
        logout = FGDB::Act.new( 'Logout' )
        
        perform = nil
        assert_nothing_raised { perform = contact.perform?( perform ) }
        assert( perform )
        
        assert_nothing_raised { contact.perform( logout ) }
        assert( acts.include?( logout ) )
        assert( acts.include?( act ) )
        
        assert( !contact.loggedIn? )
        
    end 
       
    def test_041_acts2

        contact = FGDB::Contact.new
        list = FGDB::ContactList.new( 'Users' )
        login = FGDB::Act.new( 'Login' )
        
        perform = nil
        assert_nothing_raised { perform = contact.perform?( login ) }
        assert( !perform )

        assert_raises ( Exception ) { contact.perform( login ) }
        list.addContact( contact )

        perform = nil
        assert_nothing_raised { perform = contact.perform?( login ) }
        assert( perform )
        
        assert_nothing_raised { contact.perform( login ) }
        assert( contact.loggedIn? )
        
        
    end 
        

end # class ContactTests
