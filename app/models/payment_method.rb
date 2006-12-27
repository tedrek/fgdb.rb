require 'ajax_scaffold'

class PaymentMethod < ActiveRecord::Base

  def to_s
    description
  end

  def PaymentMethod.invoice
    find( :first, :conditions => ['description = ?', 'invoice'] )
  end

end
