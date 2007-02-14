require 'ajax_scaffold'

class Donation < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  has_many :payments
  has_many :gizmo_events

  def validate
    errors.add_on_empty("contact_id") unless( postal_code and ! postal_code.empty? )
    errors.add("payments", "are too little to cover required fees") unless(invoiced? or required_paid?)
    errors.add("payments", "or gizmos should include some reason to call this a donation") if
      gizmo_events.empty? and payments.empty?
    errors.add("payments", "may only have one invoice") if invoices.length > 1
  end

  def donor
    contact ?
      contact.display_name :
      "anonymous(#{postal_code})"
  end

  def contact_information
    if contact
     contact.display_name_address
    else
      ["Anonymous (#{postal_code})"]
    end
  end

  def displayed_payment_method
    payments.map {|payment| payment.payment_method.description}.uniq.join( ' ' )
  end

  def payment
    payments.join( ", " )
  end

  def reported_total
    reported_required_fee + reported_suggested_fee
  end

  def calculated_required_fee
    gizmo_events.inject(0.0) {|total, gizmo|
      total + gizmo.required_fee
    }
  end

  def calculated_suggested_fee
    gizmo_events.inject(0.0) {|total, gizmo|
      total + gizmo.suggested_fee
    }
  end

  def calculated_total
    calculated_suggested_fee + calculated_required_fee
  end

  def real_payments
    payments.select {|payment| payment.payment_method_id != PaymentMethod.invoice.id}
  end

  def invoices
    payments.select {|payment| payment.payment_method_id == PaymentMethod.invoice.id}
  end

  def money_tendered
    real_payments.inject(0.0) {|total,payment| total + payment.amount}
  end

  def amount_invoiced
    invoices.inject(0.0) {|total,payment| total + payment.amount}
  end

  def cash_donation_owed
    [0, (amount_invoiced - reported_required_fee) - cash_donation_paid].max
  end

  def cash_donation_paid
    [0, money_tendered - required_fee_paid].max
  end

  def required_fee_owed
    if invoiced? and (reported_required_fee > required_fee_paid)
        [reported_required_fee - required_fee_paid, amount_invoiced].min
    else
      0
    end
  end

  def required_fee_paid
    [reported_required_fee, money_tendered].min
  end

  def required_paid?
    money_tendered >= calculated_required_fee
  end

  def invoiced?
    payments.detect {|payment| payment.payment_method_id == PaymentMethod.invoice.id}
  end

  def total_paid?
    money_tendered >= calculated_total
  end

  def overunder(only_required = false)
    if only_required
      money_tendered - calculated_required_fee
    else
      money_tendered - calculated_total
    end
  end

end
