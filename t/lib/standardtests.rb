#!/usr/bin/ruby -w
#
# Base class for FGDB.rb unit tests.
#

module StandardTests

	def setup
        @@user = FGDB::User::login( 'god', 'sex' )
		@@factory = @@user.object_factory
	end

	def teardown
        @@user.logout
		@@factory = nil
	end

	def StandardTests.append_features( klass )
		klass.module_eval {
			class << self 
				attr_accessor :tested_class, :validations
			end
		}
		super
	end

	def test_000_initialization 
		assert_kind_of( Class, self.class.tested_class )
		assert( FGDB::Object >= self.class.tested_class )
		test = nil
		assert_nothing_raised { test = self.class.tested_class.new }
		assert_kind_of( self.class.tested_class, test )
	end

	def test_001_basicfunctions
		instance = self.class.tested_class.new
		assert_respond_to( instance, :attributes )
		assert_respond_to( instance, :readOnlyAttributes )
		assert_respond_to( instance, :writableAttributes )
		attrs = nil
		assert_nothing_raised { attrs = instance.attributes }
		assert( attrs )
		assert( ! attrs.empty? )
		writables = nil
		assert_nothing_raised { writables = instance.writableAttributes }
		assert( writables )
		attrs.each {|attribute, value|
			assert_respond_to( instance, attribute )
			
			if writables.include?( attribute )
				assert_respond_to( instance, attribute + "=" )
				assert_nothing_raised { instance.send( attribute + "=", 1 ) }
				test = nil
				assert_nothing_raised { test = instance.send( attribute ) }
				assert_equal( 1, test )
			end
		}
	end

	def test_002_validation 
		return unless self.class.validations
		instance = self.class.tested_class.new
		self.class.validations.each {|attribute, tests|
			succeeds, failures = *tests
			succeeds.each {|test|
				assert_nothing_raised { instance.send(attribute + "=", test) }
			}
			failures.each {|test|
				assert_raises( FGDB::InvalidValueError,
							   "#{test.to_s} should not be allowable."
							   ) { instance.send(attribute + "=", test) }
			}
		}		
	end

end # module StandardTests
