#!/usr/bin/ruby
#
#   FGDB.rb installation script
#   $Id$
#

require './utils.rb'
include UtilityFunctions

require 'rbconfig'
require 'find'
require 'ftools'

include Config

$version	= %q$Rev$
$rcsId		= %q$Id$

stty_save = `stty -g`.chomp
trap("INT") { system "stty", stty_save; exit }

# Define required libraries
RequiredLibraries = [
	# libraryname, nice name, RAA URL, Download URL
	["postgres", "Ruby-Postgres",
	 "http://raa.ruby-lang.org/project/postgres/",
	 "http://www.postgresql.jp/interfaces/ruby/archive/ruby-postgres-0.7.1.tar.gz"],
	["arrow", "Arrow Web Application",
	 "http://raa.ruby-lang.org/project/arrow",
	 "http://www.rubycrafters.com/projects/Arrow/Arrow-0.1.0.tar.gz"],
]

class Installer

	@@PrunePatterns = [
		/CVS/,
		/\.svn/,
		/~$/,
		%r:(^|/)\.:,
		/authorsection/,
		/\.tpl$/,
	]

	def initialize( testing=false )
		@ftools = (testing) ? self : File
	end

	### Make the specified dirs (which can be a String or an Array of Strings)
	### with the specified mode.
	def makedirs( dirs, mode=0755, verbose=false )
		dirs = [ dirs ] unless dirs.is_a? Array

		oldumask = File::umask
		File::umask( 0777 - mode )

		for dir in dirs
			if @ftools == File
				File::mkpath( dir, $verbose )
			else
				$stderr.puts "Make path %s with mode %o" % [ dir, mode ]
			end
		end

		File::umask( oldumask )
	end

	def install( srcfile, dstfile, mode=nil, verbose=false )
		dstfile = File.catname(srcfile, dstfile)
		unless FileTest.exist? dstfile and File.cmp srcfile, dstfile
			$stderr.puts "   install #{srcfile} -> #{dstfile}"
		else
			$stderr.puts "   skipping #{dstfile}: unchanged"
		end
	end

	public

	def installFiles( src, dstDir, mode=0444, verbose=false )
		directories = []
		files = []
		
		if File.directory?( src )
			Find.find( src ) {|f|
				Find.prune if @@PrunePatterns.find {|pat| f =~ pat}
				next if f == src

				if FileTest.directory?( f )
					directories << f.gsub( /^#{src}#{File::Separator}/, '' )
					next 

				elsif FileTest.file?( f )
					files << f.gsub( /^#{src}#{File::Separator}/, '' )

				else
					Find.prune
				end
			}
		else
			files << File.basename( src )
			src = File.dirname( src )
		end
		
		dirs = [ dstDir ]
		dirs |= directories.collect {|d| File.join(dstDir,d)}
		makedirs( dirs, 0755, verbose )
		files.each {|f|
			srcfile = File.join(src,f)
			dstfile = File.dirname(File.join( dstDir,f ))

			if verbose
				if mode
					$stderr.puts "Install #{srcfile} -> #{dstfile} (mode %o)" % mode
				else
					$stderr.puts "Install #{srcfile} -> #{dstfile}"
				end
			end

			@ftools.install( srcfile, dstfile, mode, verbose )
		}
	end

end

if $0 == __FILE__
	header "FGDB.rb Installer #$version"

	unless RUBY_VERSION >= "1.8.1" || ENV['NO_VERSION_CHECK']
		abort "FGDB.rb will not run under this version of Ruby. It " +
			"requires at least 1.8.1.\nRe-run again with NO_VERSON_CHECK " +
			"set to ignore this check."
	end

	for lib in RequiredLibraries
		testForRequiredLibrary( *lib )
	end

	viewOnly = ARGV.include? '-n'
	verbose = ARGV.include? '-v'

	debugMsg "Sitelibdir = '#{CONFIG['sitelibdir']}'"
	sitelibdir = CONFIG['sitelibdir']
	debugMsg "Sitearchdir = '#{CONFIG['sitearchdir']}'"
	sitearchdir = CONFIG['sitearchdir']

	message "Installing\n"
	i = Installer.new( viewOnly )
	i.installFiles( "lib", sitelibdir, 0444, verbose )
end
