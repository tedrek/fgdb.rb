require File.dirname(__FILE__) + '/../test_helper'

class MockDB
  def self.table_name
    "mockdb"
  end
  def payments
    nil
  end
end

class ConditionsTest < Test::Unit::TestCase

  def setup
    @conditions = Conditions.new
  end


  def test_that_conditions_should_init_with_reasonable_defaults
    assert_equal Date.today, @conditions.date
    assert_equal 'daily', @conditions.date_type
    assert_nil @conditions.payment_method_id, "should not have a default payment method"
    assert_nil @conditions.contact_id, "should not have a default contact"
    assert_nil @conditions.transaction_id
  end

  def test_that_conditions_should_take_payment_method_to_override_defaults
    @conditions = Conditions.new( :payment_method_id => 1 )
    assert_equal 1, @conditions.payment_method_id, "payment_method_id should be set"
    assert_nil @conditions.contact_id
    assert_nil @conditions.date_type
    assert_nil @conditions.date
  end

  def test_that_conditions_should_generate_where_clause
    retval = nil
    assert_nothing_raised {retval = @conditions.conditions(MockDB)}
    assert_kind_of Array, retval
    assert retval.include?(@conditions.date)
    assert retval[0].include?('created_at')
  end

  def test_that_conditions_should_generate_compound_where_clause
    options = {
      :date => Date.today,
      :date_type => 'daily',
      :use_date_range => true,
      :payment_method_id => 3,
      :use_payment_method => true,
      :contact_id => 5,
      :use_contact => true,
    }
    @conditions.apply_conditions(options)
    retval = nil
    assert_nothing_raised {retval = @conditions.conditions(MockDB)}
    assert retval.include?(options[:date]), "Should have the date"
    assert retval[0].include?('created_at')
    assert retval.include?(options[:contact_id]), "Should have the contact_id"
    assert retval[0].include?('contact_id')
    assert retval.include?(options[:payment_method_id]), "Should have the payment method id"
    assert retval[0].include?('payment_method_id')
    assert retval[0].include?('AND')
  end

end
