#!/usr/bin/ruby -w
#
#   task api tests
#

class TaskTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::Task

	self.validations = {
		"hours" => [ [
				"1", 1.2, 0
			], [
				"-1", -2, nil
			] ],
	}

end
