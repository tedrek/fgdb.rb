#!/usr/bin/ruby -w
#
#   data layer tests
#

class DataTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

    @@tablenames = %w[ Gizmo Contact Users ]

    def test_010_basics 
		@@tablenames.each {|name|
			table = FGDB::Data.const_get(name)
			assert_kind_of( Class, table )
			new = nil
			assert_nothing_raised { new = table.new }
			assert_kind_of( table, new )
			
		}
    end

	def test_020_config
		assert_raises( FGDB::UninitializedError )   { FGDB::Data::db }
		config = FGDB::Config.new( File.join( File.dirname( File.dirname( __FILE__ ) ), "etc", "fgdb.conf" ) )
		assert_nothing_raised		    { FGDB::Data::setup( config ) }
		assert                          FGDB::Data::db
	end

	def test_030_lookup
		users = nil
		assert_nothing_raised           { users = FGDB::Data::Users.all }
		assert							users.length > 2
		user = nil
		assert_nothing_raised           { user = FGDB::Data::Users[2] }
		assert_equal                    2, user['id']
		assert_equal                    'rseymour', user['username']
		FGDB::Data::Users.fields.each {|field|
			assert                      user[field]
		}

		assert_nothing_raised           { user = FGDB::Data::Users["moo"] }
		assert_equal                    nil, user
	end

	def test_040_permanance 
		user = nil
		assert_nothing_raised           { user = FGDB::Data::Users[2] }

		assert_nothing_raised           { user['username'] = 'mrblock' }
		assert_equal                    'mrblock', user['username']
		assert_nothing_raised           { user.save }
		assert_equal                    'mrblock', FGDB::Data::Users[2]['username']
		assert_nothing_raised           { user['username'] = 'rseymour' }
		assert_equal                    'rseymour', user['username']
		assert_nothing_raised           { user.save }
	end

end # class DataTests
