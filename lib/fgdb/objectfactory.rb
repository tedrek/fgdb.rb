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

class FGDB::ObjectFactory < Module

	def initialize( user )
		@user = user
	end

	def const_missing( const )
		if @user.logged_in?
			if @user.name == 'guest'
				nil
			else
				FGDB.const_get( const )
			end
		else
			raise FGDB::UnauthorizedError
		end
	end

end # class FGDB::ObjectFactory
