require 'ajax_scaffold'

class SaleTxn < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  belongs_to :payment_method
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
    # :TODO:
  end

  def total_paid?
    money_tendered >= calculated_total
  end

end
