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
# $Id$
#
# == Authors
#
# * Martin Chase <mchase@freegeek.org>
#

require 'yaml'

class FGDB::Config

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	attr_reader :data

	def initialize( filename )
		File.open( filename ) {|file|
			@data = YAML::load( file.read )
		}
		self.data.freeze
	end

	def []( key )
		self.data[key]
	end

	def has_key?( key )
		self.data.has_key?( key )
	end

end # class FGDB::Config
