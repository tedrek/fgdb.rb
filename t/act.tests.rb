#!/usr/bin/ruby -w
#
#   act api tests
#

class ActTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::Act

	self.validations = {
	}

end
