#!/usr/bin/ruby
#
#
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#
# == Subversion ID
#
# $Id: contactlist.rb 61 2005-02-10 23:12:46Z stillflame $
#
# == Authors
#
# * Martin Chase <mchase@freegeek.org>
#

require 'fgdb/object'

class FGDB::ContactList < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev: 61 $

	# SVN Id
	SVNId = %q$Id: contactlist.rb 61 2005-02-10 23:12:46Z stillflame $

	# SVN URL
	SVNURL = %q$URL$

	addAttributes( "contacts", "remarks", "permissions" )
	addAttributes( "listname" ) {|value|
		value and
			value.respond_to?(:to_s) and
			value.to_s.strip.length < 256 and
			value.to_s.strip.length > 0
	}

	def initialize()
		self.contacts ||= []
		self.permissions ||= []
	end

	def addContact( contact )
		self.contacts << contact
		contact.addToList( self )
	end

	def removeContact( contact )
		self.contacts.delete( contact )
		contact.removeFromList( self )
	end

	def grant( permission )
		self.permissions << permission
	end

end # class FGDB::ContactList
