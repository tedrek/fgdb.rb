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

	addAttributes( *%w[ type contact date ] )

	addAttributes( "hours" ) {|value|
		value and value.respond_to?(:to_f) and value.to_f >= 0
	}

end # class FGDB::Task
