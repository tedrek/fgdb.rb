#!/usr/bin/ruby
#
#
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#
# == Subversion ID
# 
# $Id: acttype.rb 61 2005-02-10 23:12:46Z stillflame $
# 
# == Authors
# 
# * Martin Chase <mchase@freegeek.org>
# 

require 'fgdb/object'

class FGDB::ActType < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev: 61 $

	# SVN Id
	SVNId = %q$Id: acttype.rb 61 2005-02-10 23:12:46Z stillflame $

	# SVN URL
	SVNURL = %q$URL$

	addAttributes( "type" )

end # class FGDB::ActType
