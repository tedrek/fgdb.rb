#!/usr/bin/ruby
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#

require 'fgdb/utils'
require 'postgres'

module FGDB
	module Data

		### Base class of the database
		class DBRecord
		end # class DBRecord

	end # module Data
end # module FGDB

FGDB::requireAllFromPath( 'fgdb/data' )
