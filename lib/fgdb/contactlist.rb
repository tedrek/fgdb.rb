#!/usr/bin/ruby
#
#
#
# == Subversion ID
#
# $Id$
#
# == Authors
#
# * Martin Chase <mchase@freegeek.org>
#

require 'fgdb/object'

class FGDB::ContactList < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	add_attributes( "contacts", "remarks" )
	add_attributes( "listname" ) {|value|
		value and
			value.respond_to?(:to_s) and
			value.to_s.strip.length < 256 and
			value.to_s.strip.length > 0
	}

	def initialize()
		self.contacts ||= []
	end

	def addContact( contact )
		self.contacts << contact
		contact.addToList( self )
	end

end # class FGDB::ContactList
