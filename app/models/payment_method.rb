require 'ajax_scaffold'

class PaymentMethod < ActiveRecord::Base

  def to_s
    description
  end

  def PaymentMethod.cash
      @@cash ||= find( :first, :conditions => ['description = ?', 'cash'] )
  end

  def PaymentMethod.invoice
      @@invoice ||= find( :first, :conditions => ['description = ?', 'invoice'] )
  end

end
