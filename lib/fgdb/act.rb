#!/usr/bin/ruby
#
# This file contians the class definition for the Act class.
#
# == Subversion ID
# 
# $Id$
# 
# == Authors
# 
# * Martin Chase <mchase@freegeek.org>
# 

require 'fgdb/work'

class FGDB::Act < FGDB::Work

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	addAttributes( *%w[ type contact date ] )

	addAttributesReadOnly( *%w[ created modified ] )

end # class FGDB::Act
