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
require 'dbi'

module FGDB::Data

	module_function

	def setup( config )
		dbconfig = config['database']
		@@dbh = DBI.connect( 'DBI:Pg:%s:%s' % [ dbconfig['dbname'], dbconfig['hostname'] ],
							 dbconfig['username'], dbconfig['password'] )
	end

	def db
		self.class_variables.include?('@@dbh') ?
			@@dbh :
			raise( FGDB::UninitializedError, "Database has not been setup." )
	end

	class DBRecord < FGDB::Object

		include Enumerable

		class << self

			def db
				FGDB::Data::db
			end

			def table; end

			def fields; end

			def key; "id"; end

			# Return all the entries in this table.
			def all
				sql = "SELECT %s FROM %s" % [ self.fields.join(", "), self.table ]
				self.db.execute( sql ).fetch_all
			rescue DBI::DatabaseError => e
				nil
			end

			# Iterate over each of the entries in this table.
			def each( &block )
				self.all.each( &block )
			end

			def []( key )
				sql = "SELECT %s FROM %s WHERE %s = ?" % [ self.fields.join(", "), self.table, self.key ]
				self.new( self.db.execute( sql, key ).fetch )
			rescue DBI::DatabaseError => e
				nil
			end

		end # class << self

		def initialize( values = nil )
			@data = values
		end

		attr_reader :data

		def []( key )
			self.data[key]
		end

	end # class DBRecord

end # module FGDB::Data

FGDB::requireAllFromPath( 'fgdb/data' )
