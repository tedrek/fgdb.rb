#!/usr/bin/ruby -w
#
#   contactlist api tests
#

class ContactListTests < Test::Unit::TestCase

	include StandardTests

	self.tested_class = FGDB::ContactList

	self.validations = {

		"listname" => [ [
				"foo", "Builders", "short people", "#1's", "3D Modeling Group"
			],
					   [
				"a" * 1000, " " * 5, nil
			] ],

		"remarks" => [ [
				"this is a remark", "", nil, 
			],
					  [
				# no failing tests
			] ],

#		"" => [ [ ], [ ] ],
	}

	def test_040_add_contact 
		# :TODO:
	end

end # class ContactListTests
