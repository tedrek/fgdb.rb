#!/usr/bin/ruby
#
# This file contains the User class.
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
require 'md5'

class FGDB::User < FGDB::Object

	# SVN Revision
	SVNRev = %q$Rev$

	# SVN Id
	SVNId = %q$Id$

	# SVN URL
	SVNURL = %q$URL$

	# module funtions
	class << self

		def login( name, pass = nil )
			user = self.allocate
			user.send( :initialize, name )
			raise FGDB::LoginError unless user.valid_password?( pass )
			user
		end

		undef_method :new

	end # class << self

	def initialize( name )
		@name = name
		self.password = "sex"
	end

	attr_reader :name

	def password=( pass )
		@pass = MD5::hexdigest( pass )
	end

	def commit 
	end

	def logout 
	end

	def valid_password?( pass )
		@pass == MD5::hexdigest( pass )
	end

	def contact 
		FGDB::Contact.new
	end

	#######
	private
	#######

end # class FGDB::User
