#!/usr/bin/ruby -w
#
#   data layer tests
#

require 'fgdb/data'

class DataTests < Test::Unit::TestCase

    def setup 
    end

    def teardown 
    end

    @@tablenames = %w[ Gizmo Contact ]

    def test_010_initialization 
	@@tablenames.each {|name|
	    table = FGDB::Data.const_get(name)
	    assert_kind_of( Class, table )
	    new = nil
	    assert_nothing_raised {new = table.new}
	    assert_kind_of( table, new )
	}
    end

end # class DataTests
