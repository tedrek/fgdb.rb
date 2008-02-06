namespace :doc do
  desc "Generate documentation for the application"
  Rake::RDocTask.new("app") { |rdoc|
    rdoc.rdoc_dir = 'doc/app'
    rdoc.title    = "Rails Application Documentation"
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('doc/README_FOR_APP')
    rdoc.rdoc_files.include('app/**/*.rb')
    rdoc.rdoc_files.include('lib/**/*.rb')
    # Add other files you want included in the rdoc here.
    # Globs also work good
    rdoc.rdoc_files.include('doc/gizmo-FAQ')
    rdoc.rdoc_files.include('doc/LICENSE')
    rdoc.rdoc_files.include('doc/examples/*')
  }
end
