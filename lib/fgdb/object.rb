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

		def add_attributes( *attrs )
			self.attributes ||= []
			self.attributes += attrs
			attrs.each {|attribute|
				attr_accessor attribute.intern
			}
		end

	end # class << self

	add_attributes( *%w[ id ] )

	def attributes 
		self.class.attributes
	end

end # class FGDB::Object
