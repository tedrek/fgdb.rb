require 'ajax_scaffold'

class Donation < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  belongs_to :payment_method
  has_many :gizmo_events

  validates_presence_of :payment_method_id

  def to_s
    "$%0.2f from %s on %s (#%i)" % [money_tendered, donor, created_at.to_date.to_s, id]
  end

  def donor
    contact ?
      contact.display_name :
      "anonymous(#{postal_code})"
  end

end
