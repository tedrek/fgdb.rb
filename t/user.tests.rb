#!/usr/bin/ruby -w
#
#   user api tests
#

class UserTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::User

	def test_020_login
    
		assert_nothing_raised { user = FGDB::UserFactory.login( 'god', 'sex' ) }
        assert( user.username == 'god' )
        assert_raises( FGDB::LoginError ) { FGDB::UserFactory.login( 'god', 'blah' ) }
        assert_raises( Exception ) { FGDB::User.new }
        assert_kind_of( user, FGDB::User )
        assert_respond_to( user, :contact )
        assert_kind_of( user.contact, FGDB::Contact )

        assert_nothing_raised { user.password = 'blah' }
        assert_nothing_raised { user.commit }
        assert_raises( FGDB::LoginError) { FGDB::UserFactory.login( 'god', 'sex' ) }
        assert_nothing_raised { user = FGDB::UserFactory.login( 'god', 'blah' ) }
        assert_nothing_raised { user.password = 'sex' }
        assert_nothing_raised { user.commit }

        assert_nothing_raised { user = FGDB::UserFactory.login( 'god', 'sex' ) }
        assert_raises( FGDB::LoginError ) { FGDB::UserFactory.login( 'god', 'blah' ) }
     
        
	end
       

end # class UserTests
