#!/usr/bin/ruby
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#

class FGDB::Data::Users < FGDB::Data::DBRecord

	class << self

		def table; "users"; end

		def fields
			%w[ id username password ]
		end

		def primary_key; "id"; end

	end

end # class FGDB::Data::Users
