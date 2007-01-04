require 'ajax_scaffold'

class PaymentMethod < ActiveRecord::Base

  def to_s
    description
  end

  def PaymentMethod.cash
    find( :first, :conditions => ['description = ?', 'cash'] )
  end

end
