#!/usr/bin/ruby
#
# This file contains the FGDB module, the top-level namespace for all
# the FGDB classes and utilities.  Requiring this module loads all of
# the FGDB libraries.
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


### The module which contains all fo the base FreeGeek DataBase
### classes and utilities.
module FGDB

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	# This is the only public interface FGDB should have - INCLUDING
	# all classes underneath FGDB.
	def FGDB.login( name, pass )
		FGDB::User.login( name, pass )
	end

end # module FGDB

require 'fgdb/utils'
FGDB::requireAllFromPath( 'fgdb' )
