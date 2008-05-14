#!/usr/bin/ruby

Dir.glob("**/" + "*.rhtml").each do |this|
system("svn mv #{this} #{this.sub(/\.rhtml$/, '.html.erb')}")
end

