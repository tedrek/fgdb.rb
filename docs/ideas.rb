#!/usr/bin/ruby

class DBRecord

	def initialize 
	end

	class << self

		def db 
		end

		def new 
		end

		def new_from_user_input(input)
		end

		def table_id 
		end

		def foreign_key(table)
		end

	end # class << self

end # class DBRecord


class Contact < DBRecord

	def sales 
		Sales.all_by_contact(self)
	end

end # class Contact


class Sales < DBRecord

	class << self

		def all_by_contact(contact)
			sql = "SELECT * FROM %s AS s LEFT JOIN %s AS l ON (l.%s = s.%s) WHERE (%s = ?)"
			sql %= [ table_name, SalesLine.table_name,
				SalesLine.foreign_key(Sales),
				Sales.table_id, contact.table_id
			]
			stmt = db.prepare(sql)
			db_result = db.execute(stmt, contact[contact.table_id])
			results = {}
			db_result.each {|record|
				record.delete(id) # :MC: php's adodb shit
				results[record.id] ||= Sales.new_from_data(record)
				results[record.id].add_sales_line( SalesLine.new_from_data(record) )
			}
			return( results.to_a.map {|id, record| record} )
		end

	end # class << self

	def add_sales_line(line)
		@lines << line
	end

end # class Sales


class SalesLine < DBRecord

end # class SalesLine
