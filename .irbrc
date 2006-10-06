#!/usr/bin/ruby

require 'irb/completion'

# Allow local .irbrc to override instead of the other way around.
if Dir.pwd != ENV['HOME'] && File.exists?( ".irbrc" )
   begin
	   puts "Requiring local .irbrc..."
	   Kernel::load( ".irbrc" )
   rescue Exception => e
	   $stderr.puts "Ack! Irb startup script failed to load: #{e.message}\n\t" +
		   e.backtrace.join( "\n\t" )
   end
else

	module MyUtilityFunctions

		# Set some ANSI escape code constants (Shamelessly stolen from Perl's
		# Term::ANSIColor by Russ Allbery <rra@stanford.edu> and Zenin <zenin@best.com>
		AnsiAttributes = {
			'clear'      => 0,
			'reset'      => 0,
			'bold'       => 1,
			'dark'       => 2,
			'underline'  => 4,
			'underscore' => 4,
			'blink'      => 5,
			'reverse'    => 7,
			'concealed'  => 8,

			'black'      => 30,   'on_black'   => 40, 
			'red'        => 31,   'on_red'     => 41, 
			'green'      => 32,   'on_green'   => 42, 
			'yellow'     => 33,   'on_yellow'  => 43, 
			'blue'       => 34,   'on_blue'    => 44, 
			'magenta'    => 35,   'on_magenta' => 45, 
			'cyan'       => 36,   'on_cyan'    => 46, 
			'white'      => 37,   'on_white'   => 47
		}

		module_function

		def ansiCode( *attributes )
			attr = attributes.collect {|a| AnsiAttributes[a] ? AnsiAttributes[a] : nil}.compact.join(';')
			if attr.empty? 
				return ''
			else
				return "\e[%sm" % attr
			end
		end

		def colored( prompt, *args )
			return ansiCode( *(args.flatten) ) + prompt + ansiCode( 'reset' )
		end
	end

	# Modify prompt to do highlighting unless we're running in an inferior shell.
# 	unless ENV['EMACS']
#  		IRB.conf[:PROMPT][:MY_PROMPT] = { # name of prompt mode
#  			:PROMPT_I => MyUtilityFunctions::colored( "%N(%m):%03n:%i>", %w{bold yellow on_blue} ) + " ",
#  			:PROMPT_S => MyUtilityFunctions::colored( "%N(%m):%03n:%i%l", %w{white on_blue} ) + " ",
#  			:PROMPT_C => MyUtilityFunctions::colored( "%N(%m):%03n:%i*", %w{white on_blue} ) + " ",
#  			:RETURN => "    ==> %s\n\n"      # format to return value
#  		}
# 		IRB.conf[:PROMPT_MODE] = :MY_PROMPT
# 	end
end

HISTFILE = "~/.irb.hist"
MAXHISTSIZE = 100

begin
	if defined? Readline::HISTORY
		histfile = File::expand_path( HISTFILE )
		if File::exists?( histfile )
			lines = IO::readlines( histfile ).collect {|line| line.chomp}
			puts "Read %d saved history commands from %s." %
				[ lines.nitems, histfile ] if $DEBUG || $VERBOSE
			Readline::HISTORY.push( *lines )
		else
			puts "History file '%s' was empty or non-existant." %
				histfile if $DEBUG || $VERBOSE
		end

		Kernel::at_exit {
			lines = Readline::HISTORY.to_a.uniq
			lines = lines[ -100, 100 ] if lines.nitems > 100
			$stderr.puts "Saving %d history lines to %s." %
				[ lines.length, histfile ] if $VERBOSE || $DEBUG
			File::open( histfile, File::WRONLY|File::CREAT|File::TRUNC ) {|ofh|
				lines.each {|line| ofh.puts line }
			}
		}
	end
end

__END__
Local Variables:
mode: ruby

