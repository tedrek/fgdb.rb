#!/usr/bin/ruby -w
#
#   user api tests
#

class UserTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::User

	self.test_initialization_parameters = %w[ dummy ]

	def test_020_creation_with_permissions
		user = nil
		assert_nothing_raised       { user = FGDB.login( 'god', 'sex' ) }
		assert						user
		factory = user.object_factory
		assert						factory
		assert_kind_of				Class, factory::User
		dummy = nil
		assert_nothing_raised       { dummy = factory::User.new( 'dummy' ) }
		assert_kind_of				factory::User, dummy
		assert_nothing_raised       { dummy.delete }

		user.logout
		assert_raises( FGDB::UnauthorizedError )             { factory::User.new( 'meow' ) }
	end

	def test_021_unauthorized_users 
		guest = nil
		assert_nothing_raised       { guest = @@factory::User.login( 'guest' ) }
		assert                      guest
		assert                      factory = guest.object_factory
		assert_equal                nil, factory::User
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
