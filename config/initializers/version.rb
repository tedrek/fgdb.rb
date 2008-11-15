FGDB_VERSION = `#{RAILS_ROOT}/script/version`.chomp
require 'yaml'
PROJECT_NAME = YAML.load(File.read([RAILS_ROOT, "app.yaml"].join("/")))['name']
