#!/usr/bin/ruby -w
#
#   superclass FGDB::Object api tests
#

class ObjectTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::Object

	self.validations = {
		"id" => [ [
				1, "1"
			], [
				0, "-1", nil, "meow", 1.4
			] ],
	}
end # end class ObjectTests
