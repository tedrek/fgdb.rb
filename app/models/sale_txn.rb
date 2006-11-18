require 'ajax_scaffold'

class SaleTxn < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  #validates_associated :contact
  belongs_to :payment_method
  #validates_associated :payment_method
  has_many :gizmo_events

  def to_s
    id
    #"id: $ #{net_amount}"
  end

end
