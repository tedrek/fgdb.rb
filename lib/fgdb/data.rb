#!/usr/bin/ruby
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#

require 'fgdb/utils'
require 'fgdb/object'
require 'postgres'

module FGDB::Data

	module_function

	def setup( config )
		dbconfig = config['database']
		@@db = PGconn.connect( dbconfig['hostname'], nil, nil, nil, # port, opts, stuff?
							   dbconfig['dbname'],
							   dbconfig['username'],
							   dbconfig['password'] )
	end

	def db
		@@db
	end

	class DBRecord < FGDB::Object

		include Enumerable

		class << self

			def db
				FGDB::Data::db or raise( FGDB::UninitializedError, "Database has not been setup." )
			end

			def table; end

			def fields; end

			def key; "id"; end

			# Return all the entries in this table.
			def all
				sql = "SELECT %s FROM %s" % [ self.fields.join(", "), self.table ]
				results = self.db.exec( sql )
				results.map {|res|
					results.fields.inject({}) {|hash,key|
						hash[key] = res.shift
						hash
					}
				}
			rescue PGError
				nil
			end

			# Iterate over each of the entries in this table, as hashes.
			def each_raw( &block )
				self.all.each( &block )
			end

			# Iterate over each of the entries in this table, as DBRecord objects.
			def each( &block )
				self.all.map {|rec| self.new(rec)}.each( &block )
			end

			def []( key )
				sql = "SELECT %s FROM %s WHERE %s = '%s'" % [ self.fields.join(", "), self.table,
															  self.key, self.db.class.escape(key.to_s) ]
				results = self.db.exec( sql )
				self.new( results.fields.zip( results[0] ) )
			rescue PGError
				nil
			end

		end # class << self

		def initialize( *args )
		end

		def []( key )
			2
		end

	end # class DBRecord

end # module FGDB::Data

FGDB::requireAllFromPath( 'fgdb/data' )
