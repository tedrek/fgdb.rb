#!/usr/bin/ruby
#
# This file contains the FGDB module, the top-level namespace for all
# the FGDB classes and utilities.  Requiring this module loads all of
# the FGDB libraries.
#
# == Subversion ID
# 
# $Id$
# 
# == Authors
# 
# * Martin Chase <mchase@freegeek.org>
# 


### The module which contains all fo the base FreeGeek DataBase
### classes and utilities.
module FGDB

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

end # module FGDB

require 'fgdb/utils'
FGDB::requireAllFromPath( 'fgdb' )
