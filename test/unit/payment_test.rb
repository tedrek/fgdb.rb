require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < Test::Unit::TestCase
  fixtures :payments

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
