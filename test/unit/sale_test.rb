require File.dirname(__FILE__) + '/../test_helper'

class SaleTest < Test::Unit::TestCase
  load_all_fixtures

  NO_INFO = {
    :created_by => 1,
  }
  WITH_CONTACT_INFO = NO_INFO.merge({:postal_code => '54321',
                                     :contact_type => 'anonymous',
                                    })

  def sold_system_event
    {
      :gizmo_type_id => GizmoType.find(:first, :conditions => ['description = ?', 'System']).id,
      :gizmo_count => 1,
      :unit_price => 1,
      :gizmo_context => GizmoContext.sale
    }
  end

  def pay_a_dollar
    Payment.new({:amount => 1, :payment_method_id => 1})
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

  def test_that_gizmo_events_occurred_when_sold
    sale = Sale.new(WITH_CONTACT_INFO)
    sale.payments = [pay_a_dollar()]
    yesterday = Date.today - 1
    sale.created_at = yesterday
    sale.gizmo_events = [GizmoEvent.new(sold_system_event)]
    assert sale.save
    sale = Sale.find(sale.id)
    event = sale.gizmo_events[0]
    assert_equal sale.created_at, event.occurred_at
    assert_not_equal event.created_at, event.occurred_at
  end

end
