#!/usr/bin/ruby
#
# Base class for all objects which are in the business logic layer of
# FGDB.rb.
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#
# == Subversion ID
# 
# $Id$
# 
# == Authors
# 
# * Martin Chase <mchase@freegeek.org>
# 

class FGDB::Object
	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	#################
	# Class Methods #
	#################

	class << self

		attr_accessor :attributes

		attr_accessor :writableAttributes

		def readOnlyAttributes 
			self.attributes - self.writableAttributes
		end

		def addAttributesReadOnly( *attrs )
			self.attributes ||= []
			self.attributes += attrs
			attrs.each {|attribute|
				attr_reader attribute.intern
			}
		end

		def addAttributes( *attrs, &validator )
			addAttributesReadOnly( *attrs )
			self.writableAttributes ||= []
			self.writableAttributes += attrs
			attrs.each {|attribute|
				if validator
					define_method( attribute + "=" ) {|value|
						raise FGDB::InvalidValueError.new(
							"'#{value.inspect}' is not a valid value for the #{attribute} attribute." ) unless
							validator.call(value)
						self.instance_variable_set( "@" + attribute, value )
					}
				else
					attr_writer attribute.intern
				end
			}
		end

	end # class << self

	addAttributes( "id" ) {|value|
		value and value.respond_to?(:to_i) and value.to_f == value.to_i.to_f and value.to_i > 0
	}

	def attributes 
		self.class.attributes
	end

	def readOnlyAttributes 
		self.class.readOnlyAttributes
	end

	def writableAttributes 
		self.class.writableAttributes
	end

end # class FGDB::Object
