#!/usr/bin/ruby

require 'json'
require 'date'

find_days = 1

@found = `find /var/www/fgdb.rb/tmp/crash/ -ctime #{find_days}`.split("\n")
@found.map!{|x| j = JSON.parse(File.read(x))}
@found = @found.sort_by{|j| Date.parse(j["date"])}.map{|j|
  "#{j["date"]}: #{j["user"] ? (j["user"] + "@") : ""}#{j["controller"]}##{j["action"]}: #{j["clean_message"].gsub("\n", "\n                     ")}"
}

if @found.length >= 1
  f = `tempfile`.strip
  fi = File.open(f, "w+")
  fi.write(@found.join("\n") + "\n")
  fi.close
  system("mail -s 'database error report for #{Date.today.to_s}' ryan52 < #{f}")
  system("rm -f #{f}")
end
