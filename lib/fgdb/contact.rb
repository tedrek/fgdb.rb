#!/usr/bin/ruby
#
# This file contains the Contact class, which represents a person or
# organization, and has references to all other aspects of what that
# contact does, from buying things, to working, from adopting a
# computer, to borrowing a book.
#
# == Subversion ID
# 
# $Id$
# 
# == Authors
# 
# * Martin Chase <mchase@freegeek.org>
# 

class FGDB::Contact

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

	end # class << self

	self.attributes = %w[ id firstname middlename lastname organization
		address address2 city state zip phone fax email emailOK mailOK
		phoneOK faxOK notes modified created sortName lists ]

	self.attributes.each {|attribute|
		attr_accessor attribute.intern
	}

	####################
	# Instance Methods #
	####################

	def initialize()
	end

	def attributes 
		self.class.attributes
	end

	def addToList( list )
		self.lists ||= []
		self.lists << list
	end

end # class FGDB::Contact
