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

	add_attributes( *%w[ type contact date ] )

	add_attributes( "hours" ) {|value| value.respond_to?(:to_f) and value.to_f >= 0}

end # class FGDB::Task
