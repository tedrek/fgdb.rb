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

			def primary_key; "id"; end

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
				sql = "SELECT %s FROM %s WHERE %s = ?" % [ self.fields.join(", "), self.table, self.primary_key ]
				self.new( self.db.execute( sql, key ).fetch )
			rescue DBI::DatabaseError => e
				nil
			end

		end # class << self

		attr_reader :data

		def []( key )
			self.data[key]
		end

		def []=( key, value )
			self.data[key] = value
		end

		def key 
			self[self.class.primary_key]
		end

		def save 
			if self.key and self.class[self.key]
				update
			else
				insert
			end
		end

		#######
		private
		#######

		def initialize( values = nil )
			@data = values
		end

		def update
			clean = self.class[self.key]
			fields = self.class.fields.find_all {|field|
				self[field] != clean[field]
			}
			set_statement = fields.map {|field|
				if self[field]
					"%s=?" % field
				else
					"%s=NULL" % field
				end
			}.join( ', ' )
			sql = "UPDATE %s SET %s WHERE %s = %s" % [
				self.class.table, set_statement,
				self.class.primary_key, self.key
			]
			$stderr.puts sql
			stmt = self.class.db.prepare( sql )
			values = fields.map {|field|
				self[field]
			}
			$stderr.puts values.inspect
			stmt.execute( *values )
		end

		def insert 
			fields = self.class.fields.grep {|field|
				self[field]
			}
			sql = "INSERT INTO %s (%s) VALUES (%s)" % [
				self.table, fields.join( ', ' ),
				fields.map { '?' }.join( ', ' )
			]
			values = fields.map {|field|
				self[field]
			}
			stmt = self.class.db.prepare( sql )
			stmt.execute( *values )
		end

	end # class DBRecord

end # module FGDB::Data

FGDB::requireAllFromPath( 'fgdb/data' )
