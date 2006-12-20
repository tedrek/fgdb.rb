require 'ajax_scaffold'

class SaleTxn < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  belongs_to :payment_method
  belongs_to :discount_schedule
  has_many :gizmo_events

  validates_presence_of :payment_method_id

  def to_s
    "$%0.2f from %s on %s (#%i)" % [money_tendered, buyer, created_at.to_date.to_s, id]
  end

  def buyer
    contact ?
      contact.display_name :
      "anonymous(#{postal_code})"
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
