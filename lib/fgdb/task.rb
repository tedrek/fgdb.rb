#!/usr/bin/ruby
#
# This file contians the class definition for the Task class.
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

class FGDB::Task < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	add_attributes( *%w[ hours type contact ] )

end # class FGDB::Task
