#!/usr/bin/ruby
#
# This file contians the class definition for the Act class.
#
# == Copyright
#
# Copyright (c) 2005, Freegeek.  Some rights reserverd.  This is free
# software, subject to the terms of the GNU General Public License.
# See the LICENSE file for details.
#
# == Subversion ID
# 
# $Id: act.rb 61 2005-02-10 23:12:46Z stillflame $
# 
# == Authors
# 
# * Martin Chase <mchase@freegeek.org>
# 

require 'fgdb/work'

class FGDB::Act < FGDB::Work

	# SVN Revision
	SVNRev = %q$Rev: 61 $

	# SVN Id
	SVNId = %q$Id: act.rb 61 2005-02-10 23:12:46Z stillflame $

	# SVN URL
	SVNURL = %q$URL$

	addAttributes( *%w[ type contact date ] )

	addAttributesReadOnly( *%w[ created modified ] )

end # class FGDB::Act
