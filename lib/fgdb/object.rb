#!/usr/bin/ruby
#
# Base class for all objects which are in the business logic layer of
# FGDB.rb.
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

		def add_attributes( *attrs, &validator )
			self.attributes ||= []
			self.attributes += attrs
			attrs.each {|attribute|
				attr_reader attribute.intern
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

	add_attributes( *%w[ id ] )

	def attributes 
		self.class.attributes
	end

end # class FGDB::Object
