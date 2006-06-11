
SCHEMADUMPFILE = 'db/schema.sql'
DATADUMPFILE = 'db/devel_data.sql'

def dump_metadata( rails_env = "development" )
  abcs, search_path = setup_environment(rails_env)
  case abcs[rails_env]["adapter"] 
  when "postgresql"
    print "Dumping the metadata..."
    print ":TODO:"
    puts "done"
  else 
    raise "Task not supported by '#{abcs["test"]["adapter"]}'"
  end
end

def dump_schema( rails_env = "development" )
  abcs, search_path = setup_environment(rails_env)
  case abcs[rails_env]["adapter"] 
  when "postgresql"
    print "Dumping the schema..."
    `pg_dump -i -U "#{abcs[rails_env]["username"]}" -s -x -O -f #{SCHEMADUMPFILE} #{search_path} #{abcs[rails_env]["database"]}`
    raise "Error dumping database" if $?.exitstatus == 1
    puts "done"
  else 
    raise "Task not supported by '#{abcs["test"]["adapter"]}'"
  end
end

def dump_data( rails_env = "development" )
  abcs, search_path = setup_environment(rails_env)
  case abcs[rails_env]["adapter"] 
  when "postgresql"
    print "Dumping the data..."
    `pg_dump -i -U "#{abcs[rails_env]["username"]}" -a -x -O -f #{DATADUMPFILE} #{search_path} #{abcs[rails_env]["database"]}`
    raise "Error dumping database" if $?.exitstatus == 1
    puts "done"
  else 
    raise "Task not supported by '#{abcs["test"]["adapter"]}'"
  end
end

def load_metadata( rails_env = "development" )
  abcs, search_path = setup_environment(rails_env)
  case abcs[rails_env]["adapter"] 
  when "postgresql"
    print "Loading the meta data..."
    print ":TODO:"
    puts "done"
  else 
    raise "Task not supported by '#{abcs["test"]["adapter"]}'"
  end
end

def load_schema( rails_env = "development" )
  abcs, search_path = setup_environment(rails_env)
  case abcs[rails_env]["adapter"] 
  when "postgresql"
    dbname = abcs[rails_env]['database']
    print "Droping the database..."
    `dropdb -U "#{abcs[rails_env]["username"]}" #{dbname}`
    raise "Error dropping database" if $?.exitstatus == 1
    puts "done"
    print "Creating the database..."
    `createdb -U "#{abcs[rails_env]["username"]}" #{dbname}`
    raise "Error creating database" if $?.exitstatus == 1
    puts "done"
    print "Loading the schema..."
    `psql -U "#{abcs[rails_env]["username"]}" #{dbname} -f #{SCHEMADUMPFILE}`
    raise "Error loading schema" if $?.exitstatus == 1
    puts "done"
  else 
    raise "Task not supported by '#{abcs["test"]["adapter"]}'"
  end
end

def load_data( rails_env = "development" )
  abcs, search_path = setup_environment(rails_env)
  case abcs[rails_env]["adapter"] 
  when "postgresql"
    dbname = abcs[rails_env]['database']
    print "Loading the data..."
    `psql -U "#{abcs[rails_env]["username"]}" #{dbname} -f #{DATADUMPFILE}`
    raise "Error loading data" if $?.exitstatus == 1
    puts "done"
  else 
    raise "Task not supported by '#{abcs["test"]["adapter"]}'"
  end
end


def setup_environment(rails_env)
  abcs = ActiveRecord::Base.configurations
  ENV['PGHOST']     = abcs[rails_env]["host"] if abcs[rails_env]["host"]
  ENV['PGPORT']     = abcs[rails_env]["port"].to_s if abcs[rails_env]["port"]
  ENV['PGPASSWORD'] = abcs[rails_env]["password"].to_s if abcs[rails_env]["password"]
  search_path = abcs[rails_env]["schema_search_path"]
  search_path = "--schema=#{search_path}" if search_path
  return abcs, search_path
end

namespace :db do
  namespace :metadata do

    desc "Dump the metadata-related data from devel to SQL"
    task :dump => :environment do
      dump_metadata
    end

    desc "Load the metadata to all databases"
    task :load => :environment do
      load_metadata
    end

  end # namespace :metadata

  namespace :schema do

    desc "Dump the development database to an SQL file"
    redefine_task :dump => :environment do
      dump_schema
    end

    desc "Load the database schema into the development database"
    redefine_task :load => :environment do
      load_schema
    end

  end # namespace :schema

  namespace :data do

    desc "Dump the development database (including data) to a SQL file"
    task :dump => :environment do
      dump_schema
      dump_data
    end

    desc "Fill the database with data from the dumped SQL file"
    task :load => :environment do
      load_schema
      load_data
    end

  end # namespace :data

  namespace :test do

    desc "Prepare the test database and load the schema"
    redefine_task :prepare => :environment do
      load_schema("test")
    end

  end # namespace :test

end # namespace :db
