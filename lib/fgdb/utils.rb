#!/usr/bin/ruby
# 
# This file contains various miscellaneous utility functions which don't fit
# anywhere else. They are all module functions of the FGDB module.
# 
# == Copyright
#
# Copyright (c) 2005, The FaerieMUD Consortium.  Some rights
# reserverd.  This is free software, subject to the terms of the GNU
# General Public License.  See the LICENSE file for details.
#
# == Subversion ID
# 
# $Id$
# 
# == Authors
# 
# * Michael Granger <ged@FaerieMUD.org>
# * Martin Chase <mchase@freegeek.org>
# 

require 'rbconfig'


# ### Add some stuff to the String class to allow easy transformation to Regexp
# ### and in-place interpolation.
# class String

# 	### Return the String as a regular expression that will match it.
# 	def to_re( casefold=false, extended=false )
# 		return Regexp::new( Regexp::quote(self) )
# 	end

# 	### Ideas for String-interpolation stuff courtesy of Hal E. Fulton
# 	### <hal9000@hypermetrics.com> via ruby-talk

# 	### Interpolate any '#{...}' placeholders in the string within the given
# 	### +scope+ (a Binding object).
#     def interpolate( scope )
#         unless scope.is_a?( Binding )
#             raise TypeError, "Argument to interpolate must be a Binding, not "\
#                 "a #{scope.class.name}"
#         end

# 		# $stderr.puts ">>> Interpolating '#{self}'..."

#         copy = self.gsub( /"/, %q:\": )
#         eval( '"' + copy + '"', scope )
# 	rescue Exception => err
# 		nicetrace = err.backtrace.find_all {|frame|
# 			/in `(interpolate|eval)'/i !~ frame
# 		}
# 		Kernel::raise( err, err.message, nicetrace )
#     end

# end


module FGDB

	###############
	module_function
	###############

	### Search for and require ruby module files from subdirectories of the
	### $LOAD_PATH specified by +subdir+. If excludePattern is a Regexp or a
	### String, it will be used as a pattern to exclude matching module files.
	def requireAllFromPath( subdir="fgdb", excludePattern=nil )
		excludePattern = Regexp::compile( excludePattern.to_s ) unless
			excludePattern.nil? || excludePattern.is_a?( Regexp )

		$LOAD_PATH.
			collect {|dir| File::join(dir, subdir)}.
			find_all {|dir| File::directory? dir }.
			inject([]) {|files,dir|
				files += Dir::entries(dir).find_all {|file|
					/^[-.\w]+\.(rb|#{Config::CONFIG['DLEXT']})$/.match(file)
				}
			}.
			uniq.
			reject {|file| excludePattern.match(file) unless excludePattern.nil? }.
			each {|file| require File::join(subdir, file) }
	end


	class InvalidValueError < RuntimeError; end

	class LoginError < RuntimeError; end

	class UninitializedError < RuntimeError; end

end # module FGDB

