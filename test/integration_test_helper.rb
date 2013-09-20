require 'test_helper'

# Disable transactional fixtures for integration tests as Capybara's JS drivers
# run in a seperate thread and can't see the transaction.
# https://github.com/jnicklas/capybara#transactions-and-database-setup
class ActiveSupport::TestCase
  class << self
    use_transactional_fixtures = true
  end
end

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'capybara/rails'

# Use PhantomJS as our javascript environment
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

module ActionController
  class IntegrationTest
    include Capybara::DSL
  end
end
