require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < Test::Unit::TestCase
  fixtures :payments
  
  def test_that_payments_should_use_integer_math
    pmnt = Payment.new
    assert pmnt.respond_to?(:amount)
    pmnt.amount = 2.54
    assert_equal 2, pmnt.amount_dollars
    assert_equal 54, pmnt.amount_cents
    pmnt.amount_dollars = 5
    pmnt.amount_cents = 14
    assert_equal 5.14, pmnt.amount
  end

  # Replace this with your real tests.
  def test_that_should_report_mostly_empty_without_both_amount_and_method
      assert Payment.new().mostly_empty?
      assert Payment.new({:amount => -1}).mostly_empty?
      assert Payment.new({:amount => 0}).mostly_empty?
      # Allow negative payments
      assert ! Payment.new({:amount => -1, :payment_method_id => 2}).mostly_empty?
      assert Payment.new({:amount => 0, :payment_method_id => 2}).mostly_empty?
      assert ! Payment.new({:amount => 0.01, :payment_method_id => 2}).mostly_empty?
  end
end
