#!/usr/bin/ruby
#
# This file contains the Contact class, which represents a person or
# organization, and has references to all other aspects of what that
# contact does, from buying things, to working, from adopting a
# computer, to borrowing a book.
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
		phoneOK faxOK notes lists tasks acts ] )

	addAttributesReadOnly( *%w[ modified created sortName loggedIn ] )

	####################
	# Instance Methods #
	####################

	def initialize()
		self.lists = []
		self.tasks = []
		self.acts = []
	end

	# the lists are responsible for calling this.
	def addToList( list )
		self.lists << list
	end

	# the lists are responsible for calling this.
	def removeFromList( list )
		self.lists.delete( list )
	end

	def addTask( task )
		task.contact = self
		self.tasks << task
	end

	def removeTask( task )
		self.tasks.delete( task )
		if task.contact == self
			task.contact = nil
		end
	end

	def addAct( act )
		act.contact = self
		self.acts << act
	end

	def removeAct( act )
		self.acts.delete( act )
		if act.contact == self
			act.contact = nil
		end
	end

	def hours 
		hour_sum = 0
		self.tasks.each {|task|
			hour_sum += task.hours
		}
		return hour_sum
	end

	def canPerform?( action )
		permissions = self.lists.map {|list|
			list.permissions.map {|permission|
				permission.type
			}
		}.flatten
		permissions.include?(action.type)
	end

	def perform( action )
		if self.canPerform?( action )
			case action.type
			when "Login"
				@loggedIn = true
			when "Logout"
				@loggedIn = false
			end
			self.addAct( action )
		end
	end

	def loggedIn? 
		self.loggedIn
	end

end # class FGDB::Contact
