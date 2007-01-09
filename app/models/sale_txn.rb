require 'ajax_scaffold'

class SaleTxn < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  belongs_to :payment_method
  belongs_to :discount_schedule
  has_many :gizmo_events

  def to_s
    "$%0.2f from %s on %s (#%i)" % [money_tendered, buyer, created_at.strftime('%Y-%m-%d at %H:%M'), id]
  end

  def buyer
    contact ?
      contact.display_name :
      "anonymous(#{postal_code})"
  end

  def displayed_payment_method
    txn_complete ? payment_method.description : 'invoice'
  end

  def payment
    if txn_complete
      "$%0.2f %s" % [ money_tendered, payment_method.description ]
    elsif payment_method
      "$%0.2f invoice ($%0.2f %s)" % [ reported_amount_due - money_tendered,
        money_tendered, payment_method.description ]
    else
      "$%0.2f invoice" % [ reported_amount_due ]
    end
  end

  def calculated_total
    if discount_schedule
      gizmo_events.inject(0.0) {|tot,gizmo|
        tot + gizmo.discounted_price(discount_schedule)
    }
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

  def total_paid?
    money_tendered >= calculated_total
  end

end
