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

require 'fgdb/object'

class FGDB::Contact < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	addAttributes( *%w[ firstname middlename lastname organization
		address address2 city state zip phone fax email emailOK mailOK
		phoneOK faxOK notes modified created sortName lists tasks ] )

	####################
	# Instance Methods #
	####################

	def initialize()
		self.lists = []
		self.tasks = []
	end

	def addToList( list )
		self.lists << list
	end

	def addTask( task )
		task.contact = self
		self.tasks << task
	end

	def hours 
		hour_sum = 0
		self.tasks.each {|task|
			hour_sum += task.hours
		}
		return hour_sum
	end

end # class FGDB::Contact
