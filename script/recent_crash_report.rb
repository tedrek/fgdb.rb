#!/usr/bin/env ruby

require 'json'
require 'date'

@found = `find /var/www/fgdb.rb/tmp/crash/ -mtime 0 -type f`.split("\n")
@found.map!{|x| j = JSON.parse(File.read(x))}
@found = @found.sort_by{|j| (j["date"])}.map{|j|
  "#{j["date"]}: #{j["crash_id"]}: #{j["cashier"] || j["user"] || j["client_ip"]}@#{j["controller"]}##{j["action"]}: #{j["clean_message"].gsub("\n", "\n                            ")}"
}

if @found.length >= 1
  f = `tempfile`.strip
  fi = File.open(f, "w+")
  fi.write(@found.join("\n") + "\n")
  fi.close
  system("mail -s 'database error report for #{Date.today.to_s}' database < #{f}")
  system("rm -f #{f}")
end
