#!/usr/bin/ruby
#
# This file contians the class definition for the GizmoList class.
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

class FGDB::GizmoList < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	addAttributes( "gizmos", "remarks" )

	def initialize 
		self.gizmos ||= []
	end

	def addGizmo( gizmo )
		self.gizmos << gizmo
		gizmo.addToList( self )
	end

end # class FGDB::GizmoList
