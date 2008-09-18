# -*- Ruby -*-

task :cruise do
  ['db:drop', 'db:create', 'db:data:revert_stuff', 'db:schema:load', 'db:migrate', 'autodoc', 'db:test:purge', 'db:test:prepare', 'test'].each{|x|
    puts "Raking #{x}"
    if !system("rake #{x}")
      exit 1
    end
  }
end

task :autodoc => :environment do
  abcs = setup_environment(RAILS_ENV)[0]
  base_cmdline = "postgresql_autodoc -d #{abcs[RAILS_ENV]["database"]} -f #{RAILS_ROOT}/doc/autodoc/fgdb "
  [
   "mkdir -p #{RAILS_ROOT}/doc/autodoc",
   "if ! test -h #{RAILS_ROOT}/doc/autodoc/autodoc; then ln -s . #{RAILS_ROOT}/doc/autodoc/autodoc; fi",
   base_cmdline + "-t html",
   base_cmdline + "-t dot",
   "dot -Tgif -o #{RAILS_ROOT}/doc/autodoc/fgdb.gif < #{RAILS_ROOT}/doc/autodoc/fgdb.dot",
   "rm #{RAILS_ROOT}/doc/autodoc/fgdb.dot"
#  sed -i 's*<!-- Primary Index -->*<a href="fgdb.gif"><img src="fgdb.gif" /></a><!-- Primary Index -->*' fgdb.html
  ].each do |x|
    if !system(x)
      exit 1
    end
  end
end
