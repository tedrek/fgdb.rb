require File.dirname(__FILE__) + '/../test_helper'

class SaleTest < ActiveSupport::TestCase
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
      :unit_price => "1",
      :gizmo_context => GizmoContext.sale,
      :as_is => true
    }
  end

  def pay_a_dollar
    Payment.new({:amount => "1", :payment_method_id => 1})
  end

  Test::Unit::TestCase.integer_math_test(self, "Sale", "reported_amount_due")
  Test::Unit::TestCase.integer_math_test(self, "Sale", "reported_discount_amount")

  def test_that_gizmo_events_will_have_occurred_at
    sale = Sale.new(WITH_CONTACT_INFO)
    sale.payments = [pay_a_dollar()]
    sale.gizmo_events = [GizmoEvent.new(sold_system_event)]
    sale.discount_name = DiscountName.find(:first)
    sale.discount_percentage = DiscountPercentage.find(:first, :conditions => "percentage = 0")
    assert ! sale.discount_name.nil?
    assert ! sale.discount_percentage.nil?
    assert sale.save
    sale = Sale.find(sale.id)
    event = sale.gizmo_events[0]
    assert_not_nil event.occurred_at
    assert_equal sale.created_at.to_s, event.occurred_at.to_s
  end

  def test_that_gizmo_events_occurred_when_sold
    sale = Sale.new(WITH_CONTACT_INFO)
    sale.payments = [pay_a_dollar()]
    yesterday = Date.today - 1
    sale.created_at = yesterday
    sale.occurred_at = yesterday
    sale.gizmo_events = [GizmoEvent.new(sold_system_event)]
    sale.discount_name = DiscountName.find(:first)
    sale.discount_percentage = DiscountPercentage.find(:first, :conditions => "percentage = 0")
    assert sale.save
    sale = Sale.find(sale.id)
    event = sale.gizmo_events[0]
    assert_equal sale.created_at.to_s, event.occurred_at.to_s
    assert_not_equal event.created_at.to_s, event.occurred_at.to_s
  end

end
