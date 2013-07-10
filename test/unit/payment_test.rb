require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < ActiveSupport::TestCase
  fixtures :payments
  
  Test::Unit::TestCase.integer_math_test(self, "Payment", "amount")

  def test_that_should_report_mostly_empty_with_zero_payment
      assert Payment.new({:amount => "0"}).mostly_empty?
      assert ! Payment.new({:amount => "1"}).mostly_empty?
      assert ! Payment.new({:amount => "-1"}).mostly_empty?
  end
end
