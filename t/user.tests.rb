#!/usr/bin/ruby -w
#
#   user api tests
#

class UserTests < Test::Unit::TestCase

#	include StandardTests

#	self.tested_class = FGDB::User

	def test_020_creation_with_permissions

		user = nil
		assert_nothing_raised       { user = FGDB.login( 'god', 'sex' ) }
		assert						user
		assert						user.object_factory
		assert_kind_of				Class, user.object_factory::User
		dummy = nil
		assert_nothing_raised       { dummy = user.object_factory::User.new( 'dummy' ) }
		assert.kind_of				user.object_factory::User, dummy

		factory = user.object_factory
		user.logout
		assert_raises( FGDB::UnauthorizedError )             { factory::User.new }

	end

	#:MC: ignore these until you get 020 to pass (and decide on an implementation)
# 	def test_030_login
# 		user = nil
# 		assert_nothing_raised { user = @@factory::User.login( 'god', 'sex' ) }
#         assert( user.name == 'god' )
#         assert_raises( FGDB::LoginError ) { @@factory::User.login( 'god', 'blah' ) }
#         assert_kind_of( @@factory::User, user )
#         assert_respond_to( user, :contact )
#         assert_kind_of( @@factory::Contact, user.contact )

#         assert_nothing_raised { user.password = 'blah' }
#         assert_nothing_raised { user.commit }

#         assert_nothing_raised { user.logout }
        
#         assert_raises( FGDB::LoginError) { @@factory::User.login( 'god', 'sex' ) }
#         assert_nothing_raised { user = @@factory::User.login( 'god', 'blah' ) }
#         assert_nothing_raised { user.password = 'sex' }
#         assert_nothing_raised { user.commit }
#         assert_nothing_raised { user.logout }

#         assert_nothing_raised { user = @@factory::User.login( 'god', 'sex' ) }
#         assert_raises( FGDB::LoginError ) { @@factory::User.login( 'god', 'blah' ) }

# 	end
       

end # class UserTests
