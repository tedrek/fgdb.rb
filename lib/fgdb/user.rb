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
require 'fgdb/objectfactory'
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
			user.login( pass )
			user
		end

	end # class << self

	def initialize( name )
		@name = name
		@logged_in = false
		self.password = "sex"
		@object_factory = FGDB::ObjectFactory.new(self)
	end

	addAttributes( *%w[ name ] )

	addAttributesReadOnly( *%w[ object_factory logged_in ] )

	def password=( pass )
		@pass = MD5::hexdigest( pass )
	end

	def commit 
	end

	def delete
	end

	def login( pass = nil )
		if pass
			raise FGDB::LoginError unless self.valid_password?( pass )
		end
		@logged_in = true
	end

	def logout 
		@logged_in = false
	end

	def logged_in?
		@logged_in
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
