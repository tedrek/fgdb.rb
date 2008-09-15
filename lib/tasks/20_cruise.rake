# -*- Ruby -*-

task :cruise do
  ['db:drop', 'db:create', 'db:data:revert_stuff', 'db:schema:load', 'db:migrate', 'db:test:purge', 'db:test:prepare', 'test'].each{|x|
    if !system("rake #{x}")
      exit 1
    end
  }
end
