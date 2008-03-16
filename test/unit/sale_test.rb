require File.dirname(__FILE__) + '/../test_helper'

class SaleTest < Test::Unit::TestCase
  fixtures :sales

  def test_sanity
    assert_equal 2, 1+1
  end

  def test_that_donations_use_integer_math
    pmnt = Sale.new
    assert pmnt.respond_to?(:reported_discount_amount)
    assert pmnt.respond_to?(:reported_amount_due)
    pmnt.reported_discount_amount = 2.54

    assert_equal 2, pmnt.reported_discount_amount_dollars
    assert_equal 54, pmnt.reported_discount_amount_cents
    pmnt.reported_discount_amount_dollars = 5
    pmnt.reported_discount_amount_cents = 14
    assert_equal 5.14, pmnt.reported_discount_amount

    pmnt.reported_amount_due = 2.54
    assert_equal 2, pmnt.reported_amount_due_dollars
    assert_equal 54, pmnt.reported_amount_due_cents
    pmnt.reported_amount_due_dollars = 5
    pmnt.reported_amount_due_cents = 14
    assert_equal 5.14, pmnt.reported_amount_due
  end
  
end
