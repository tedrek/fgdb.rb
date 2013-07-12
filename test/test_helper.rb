ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'

class Test::Unit::TestCase
  class << self
    def integer_math_test(my_test, class_name, field_name)
      code= "def test_that_#{class_name}s_use_integer_math_for_#{field_name}
      pmnt = #{class_name}.new
      pmnt.#{field_name} = \"2.54\"
      assert_equal 254, pmnt.#{field_name}_cents
      pmnt.#{field_name}_cents = 514
      assert_equal \"5.14\", (pmnt.#{field_name}_cents.to_f/100.0).to_s
      end"
      my_test.class_eval(code)
    end
  end
end

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #

  # Add more helper methods to be used by all tests here...

  include AuthenticatedTestHelper

  ORDERED_TABLES =
    [
     %W[users roles_users],
     %W[gizmo_events],
     %W[contacts contact_types_contacts
        contact_methods],
     %W[disbursements],
     %W[sale_types sales],
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

    def integer_math_test(my_test, class_name, field_name)
      code= "def test_that_#{class_name}s_use_integer_math_for_#{field_name}
      pmnt = #{class_name}.new
      pmnt.#{field_name} = \"2.54\"
      assert_equal 254, pmnt.#{field_name}_cents
      pmnt.#{field_name}_cents = 514
      assert_equal \"5.14\", (pmnt.#{field_name}_cents.to_f/100.0).to_s
      end"
      my_test.class_eval(code)
    end

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
  #alias_method_chain :load_fixtures, :trigger_disabling

  # An hour of programming AGO days in the past
  def an_hour_of_programming(ago=2)
    an_hour_of(46,ago)
  end

  def an_hour_of_testing(ago=2)
    an_hour_of(52,ago)
  end

  # An hour of assembly AGO days in the past
  def an_hour_of_assembly(ago=2)
    an_hour_of(26,ago, 'build')
  end

  # An hour of monitors AGO days in the past
  def an_hour_of_monitors(ago=2)
    an_hour_of(22,ago, 'adoption')
  end

  # An hour of TYPE, AGO days in the past
  def an_hour_of(type,ago=2,program='adoption')
    VolunteerTask.new({ :duration => 1.0,
                        :program =>
                        Program.find(:first,
                                     :conditions => "name = '#{program}'"),
                        :created_by => 1,
                        :date_performed => Date.today - ago,
                        :volunteer_task_type => VolunteerTaskType.find(type) })
  end

  NO_INFO = {:created_by => 1}
  WITH_CONTACT_INFO = NO_INFO.merge({:postal_code => '54321', :contact_type => 'anonymous'})

  def crt_event
    {
      :gizmo_type => GizmoType.find(:first,
                                    :conditions => ['description = ?',
                                                    'Monitor-CRT']),
      :gizmo_count => 1,
      :gizmo_context => GizmoContext.donation,
      :as_is => false
    }
  end

  def donated_system_event
    {
      :gizmo_type_id => GizmoType.find(:first, :conditions => ['description = ?', 'System']).id,
      :gizmo_count => 1,
      :gizmo_context => GizmoContext.donation,
      :as_is => false,
      :unit_price_cents => 100,
    }
  end

  def sold_system_event
    {
      :gizmo_type_id => GizmoType.find(:first, :conditions => ['description = ?', 'System']).id,
      :gizmo_count => 1,
      :gizmo_context => GizmoContext.sale,
      :as_is => true
    }
  end

  def recycled_system_event
    {
      :gizmo_type_id => GizmoType.find(:first, :conditions => ['description = ?', 'System']).id,
      :gizmo_count => 10,
      :gizmo_context => GizmoContext.recycling,
      :as_is => false
    }
  end

  def some_cash(amnt)
    some_payment(amnt, PaymentMethod.cash)
  end
  def some_check(amnt)
    some_payment(amnt, PaymentMethod.check)
  end

  def some_payment(amnt, method)
    Payment.new(:payment_method_id => method.id, :amount_cents => amnt)
  end

end
