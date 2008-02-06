ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #

  # Add more helper methods to be used by all tests here...

  ORDERED_TABLES =
    [
     %W[defaults],
     %W[gizmo_contexts gizmo_types gizmo_attrs gizmo_typeattrs
        gizmo_contexts_gizmo_types gizmo_events],
#     %W[gizmo_contexts_gizmo_typeattrs  gizmo_events_gizmo_typeattrs],
     %W[contacts contact_types contact_types_contacts
        contact_method_types contact_methods],
     %W[volunteer_task_types community_service_types],
#     %W[disbursement_types disbursements],
     %W[payment_methods],
     %W[discount_schedules discount_schedules_gizmo_types sales],
     %W[donations],
     %W[payments],
     %W[recyclings],
    ]

  class << self
    # Every Active Record database supports transactions except MyISAM tables
    # in MySQL.  Turn off transactional fixtures in this case; however, if you
    # don't care one way or the other, switching from MyISAM to InnoDB tables
    # is recommended.
    use_transactional_fixtures = true

    # Instantiated fixtures are slow, but give you @david where otherwise you
    # would need people(:david).  If you don't want to migrate your existing
    # test cases which use the @david style and don't mind the speed hit (each
    # instantiated fixtures translates to a database query per test method),
    # then set this back to true.
    use_instantiated_fixtures  = false

    def load_all_fixtures
      ORDERED_TABLES.each do |tables|
        fixtures(*(tables.map {|tbl| tbl.to_sym}))
      end
    end

  end

  def load_fixtures_with_trigger_disabling
    conn = Contact.connection
    fixture_table_names.each {|table|
      conn.execute "ALTER TABLE #{table} DISABLE TRIGGER ALL;"
    }
    load_fixtures_without_trigger_disabling
    fixture_table_names.each {|table|
      conn.execute "ALTER TABLE #{table} ENABLE TRIGGER ALL;"
    }
  end
  alias_method_chain :load_fixtures, :trigger_disabling

  # An hour of programming AGO hours in the past
  def an_hour_of_programming(ago=2)
    an_hour_of(46,ago)
  end

  def an_hour_of_testing(ago=2)
    an_hour_of(52,ago)
  end

  # An hour of assembly AGO hours in the past
  def an_hour_of_assembly(ago=2)
    an_hour_of(26,ago)
  end

  # An hour of monitors AGO hours in the past
  def an_hour_of_monitors(ago=2)
    an_hour_of(22,ago)
  end

  # An hour of TYPE, AGO hours in the past
  def an_hour_of(type,ago=2)
    VolunteerTask.new({ :duration => 1.0,
                        :start_time => Time.now - ago.hours,
                        :volunteer_task_type => VolunteerTaskType.find(type) })
  end

end
