#!/usr/bin/ruby -w

class ConfigTests < Test::Unit::TestCase


	def test_010_initialization 
		filename = File.join( File.dirname( File.dirname( __FILE__ ) ), "etc", "fgdb.conf" )
		config = nil
		assert_nothing_raised                   { config = FGDB::Config.new( filename ) }
		assert                                  config.has_key?( "database" )
		assert_kind_of                          String, config["database"]["hostname"]
	end

end # class ConfigTests
