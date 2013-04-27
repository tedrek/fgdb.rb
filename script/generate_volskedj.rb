#!/usr/bin/env ruby

#ENV['RAILS_ENV']||="production"

require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

errors = Roster.auto_generate_all
puts errors
exit(errors.length == 0)

