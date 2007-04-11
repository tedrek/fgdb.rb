class Sale < ActiveRecord::Base
  include GizmoTransaction
  belongs_to :contact, :order => "surname, first_name"  
  has_many :payments, :dependent => :destroy
  belongs_to :discount_schedule
  has_many :gizmo_events, :dependent => :destroy

  def initialize(*args)
    @contact_type = 'named'
    super(*args)
  end

  attr_accessor :contact_type  #anonymous or named

  def validate
    if contact_type == 'named'
      errors.add_on_empty("contact_id")
    else
      errors.add_on_empty("postal_code")
    end
    errors.add("payments", "are too little to cover the cost") unless invoiced? or total_paid?
    errors.add("payments", "are too much") if overpaid?
    errors.add("payments", "may only have one invoice") if invoices.length > 1
    errors.add("payments", "should include something") if payments.empty?
    errors.add("gizmos", "should include something") if gizmo_events.empty?
  end

  def buyer
    contact ?
      contact.display_name :
      "anonymous(#{postal_code})"
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

end
