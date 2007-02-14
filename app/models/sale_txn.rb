require 'ajax_scaffold'

class SaleTxn < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  has_many :payments
  belongs_to :discount_schedule
  has_many :gizmo_events

  def validate
    errors.add_on_empty("contact_id") unless( postal_code and ! postal_code.empty? )
    errors.add("payments", "are too little to cover the cost") unless invoiced? or total_paid?
    errors.add("payments", "are too much") if overpaid?
    errors.add("payments", "may only have one invoice") if invoices.length > 1
    errors.add("payments", "should include some reason to call this a sale") if payments.empty?
    errors.add("gizmos", "should include some reason to call this a sale") if gizmo_events.empty?
  end

  def buyer
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

  def calculated_total
    if discount_schedule
      (gizmo_events.inject(0.0) {|tot,gizmo|
        tot + gizmo.discounted_price(discount_schedule)
      } * 100).to_i / 100.0
    else
      calculated_subtotal
    end
  end

  def calculated_subtotal
    gizmo_events.inject(0.0) {|tot,gizmo|
      tot + gizmo.total_price.to_f
    }
  end

  def calculated_discount
    calculated_subtotal - calculated_total
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

  def invoiced?
    payments.detect {|payment| payment.payment_method_id == PaymentMethod.invoice.id}
  end

  def total_paid?
    money_tendered >= calculated_total
  end

  def overpaid?
    calculated_total < money_tendered
  end

end
