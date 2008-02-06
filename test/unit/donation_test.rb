require File.dirname(__FILE__) + '/../test_helper'

class DonationTest < Test::Unit::TestCase

#   fixtures :contact_types, :contact_method_types, :contacts, :payment_methods, :gizmo_contexts,
#     :gizmo_attrs, :gizmo_types, :gizmo_typeattrs,
#     :gizmo_contexts_gizmo_typeattrs, :gizmo_contexts_gizmo_types, :donations
  load_all_fixtures

  NO_INFO = {}
  WITH_CONTACT_INFO = NO_INFO.merge({:postal_code => '54321', :contact_type => 'anonymous'})

  def crt_event
    {
      :gizmo_type_id => GizmoType.find(:first, :conditions => ['description = ?', 'CRT']).id,
      :gizmo_count => 1,
      :gizmo_context => GizmoContext.donation
    }
  end

  def system_event
    {
      :gizmo_type_id => GizmoType.find(:first, :conditions => ['description = ?', 'System']).id,
      :gizmo_count => 1,
      :gizmo_context => GizmoContext.donation
    }
  end

  def with_gizmo
    NO_INFO.merge({:gizmo_events => [GizmoEvent.new(system_event)]})
  end

  def with_both
    with_gizmo.merge( WITH_CONTACT_INFO )
  end

  def setup
    # Retrieve fixtures via their name
    # @first = donations(:first)
  end

  def test_that_should_not_be_valid_without_contact_info
    donation = Donation.new(NO_INFO)
    assert ! donation.valid?
    #assert donation.errors.invalid?(:contact_id), "Should require contact for initialization"
  end

  def test_that_should_be_valid_with_contact_info
    donation = Donation.new(with_gizmo.merge(:postal_code => '12345'))
    assert donation.valid?
    donation = Donation.new(with_gizmo.merge(:contact_id => '1'))
    #assert donation.valid?
  end

  def test_that_should_be_valid_when_dumped
    donation = Donation.new(NO_INFO.merge({:gizmo_events => [GizmoEvent.new(crt_event)], :contact_type => 'dumped'}))
    assert donation.valid?
  end

  def test_that_should_dumped_contact_type_should_be_remembered
    donation = Donation.new(NO_INFO.merge({:gizmo_events => [GizmoEvent.new(crt_event)], :contact_type => 'dumped'}))
    donation.save
    donation = Donation.find(donation.id)
    assert_equal 'dumped', donation.donor
    assert_equal 'dumped', donation.contact_type
  end

  def test_that_anonymous_contact_without_postal_code_should_be_invalid
    donation = Donation.new(NO_INFO.merge({:gizmo_events => [GizmoEvent.new(crt_event)], :contact_type => 'anonymous'}))
    assert !donation.valid?
  end

  def test_that_should_be_able_to_get_contact_information_for_anonymous
    donation = Donation.new(with_gizmo.merge(:postal_code => '12345'))
    info = nil
    assert_nothing_raised       {info = donation.contact_information}
    assert                      info
    assert_kind_of              Array, info
    assert                      ! info.empty?
    assert_kind_of              String, info[0]
    assert_match                /12345/, info[0]
  end

  def test_that_should_sum_amounts_from_payments
    donation = Donation.new(WITH_CONTACT_INFO)
    donation.payments = []
    donation.payments << Payment.new({ :amount => 2, :payment_method_id => 3 })
    donation.payments << Payment.new({ :amount => 3.5, :payment_method_id => 2 })
    donation.payments << Payment.new({ :amount => 1, :payment_method_id => 1 })
    donation.payments << Payment.new({ :amount => 0, :payment_method_id => 1 })
    assert_equal 6.5, donation.money_tendered
  end

  def test_that_real_payments_excludes_invoices
    donation = Donation.new(WITH_CONTACT_INFO)
    donation.payments = []
    donation.payments << Payment.new({ :amount => 2, :payment_method_id => 3 })
    invoice = Payment.new({ :amount => 3.5 })
    invoice.payment_method = PaymentMethod.invoice
    donation.payments << invoice
    assert ! donation.real_payments.include?( invoice )
  end

  def test_that_should_not_include_invoices_in_payment_amount
    donation = Donation.new(WITH_CONTACT_INFO)
    donation.payments = []
    donation.payments << Payment.new({ :amount => 2, :payment_method_id => 3 })
    invoice = Payment.new({ :amount => 3.5 })
    invoice.payment_method = PaymentMethod.invoice
    donation.payments << invoice
    assert_equal 2, donation.money_tendered
  end

  def test_that_should_total_invoiced_amount
    donation = Donation.new(WITH_CONTACT_INFO)
    donation.payments = []
    donation.payments << Payment.new({ :amount => 2, :payment_method_id => 3 })
    invoice = Payment.new({ :amount => 3.5 })
    invoice.payment_method = PaymentMethod.invoice
    donation.payments << invoice
    assert_equal 3.5, donation.amount_invoiced
  end

  def test_that_should_be_able_to_tell_when_to_invoice
    donation = Donation.new(WITH_CONTACT_INFO)
    donation.payments = []
    assert ! donation.invoiced?
    donation.payments << Payment.new({ :amount => 2, :payment_method_id => 3 })
    assert ! donation.invoiced?
    invoice = Payment.new({ :amount => 3.5 })
    invoice.payment_method = PaymentMethod.invoice
    donation.payments << invoice
    assert donation.invoiced?
  end

  def test_that_required_fees_should_not_be_valid_unpaid
    donation = Donation.new(WITH_CONTACT_INFO)
    donation.payments = []
    donation.gizmo_events = [GizmoEvent.new(crt_event)]
    assert( donation.calculated_required_fee > 0, "a crt should have a required fee" )
    assert( ! donation.valid? )
  end

  def test_that_required_fees_should_be_valid_paid
    donation = Donation.new(WITH_CONTACT_INFO)
    donation.gizmo_events = [GizmoEvent.new(crt_event)]
    assert( ! donation.valid? )
    assert( donation.calculated_required_fee > 0 )
    donation.payments = [Payment.new({ :amount => 10, :payment_method_id => 3 })]
    assert( donation.valid? )
  end

  def test_that_payments_or_gizmos_are_required
    donation = Donation.new(WITH_CONTACT_INFO)
    assert ! donation.valid?
    donation.payments << Payment.new({ :amount => 10, :payment_method_id => 3 })
    assert donation.valid?
    donation.payments = []
    assert ! donation.valid?
  end

end
