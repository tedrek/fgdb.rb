require 'ajax_scaffold'

module GizmoTransaction

  def gizmos
    gizmo_events.map {|ge| ge.display_name}.join(', ')
  end

  def payment
    payments.join( ", " )
  end

  def real_payments
    payments.select {|payment| payment.payment_method_id != PaymentMethod.invoice.id}
  end

  def displayed_payment_method
    payments.map {|payment| payment.payment_method.description}.uniq.join( ' ' )
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

  def contact_information
    if contact
     contact.display_name_address
    elsif postal_code
      ["Anonymous (#{postal_code})"]
    else
      ["Dumped"]
    end
  end

  private
    def required_contact_type
      # the contact type to actually apply to a named contact who did the txn
      # used in add_contact_types
      # overridden in each class which mixes this in (not dispersments, recycling)
    end

    def add_contact_types
      unless contact_type != 'named' or
             required_contact_type == nil or
             contact.contact_types.include? required_contact_type
        contact.contact_types << required_contact_type
      end
    end

end
