#!/usr/bin/ruby
#
# This file contians the class definition for the Gizmo class.
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

class FGDB::Gizmo < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	addAttributes( "lists" )

	def initialize 
		self.lists ||= []
	end

	def addToList( list )
		self.lists << list
	end
end # class FGDB::Gizmo
