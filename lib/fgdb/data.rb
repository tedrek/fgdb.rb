#!/usr/bin/ruby

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
