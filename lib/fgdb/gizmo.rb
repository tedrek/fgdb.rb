#!/usr/bin/ruby
#
# This file contians the class definition for the Gizmo class.
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#
# == Subversion ID
# 
# $Id: gizmo.rb 61 2005-02-10 23:12:46Z stillflame $
# 
# == Authors
# 
# * Martin Chase <mchase@freegeek.org>
# 

require 'fgdb/object'

class FGDB::Gizmo < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev: 61 $

	# SVN Id
	SVNId = %q$Id: gizmo.rb 61 2005-02-10 23:12:46Z stillflame $

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
