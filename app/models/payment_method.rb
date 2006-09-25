require 'ajax_scaffold'

class PaymentMethod < ActiveRecord::Base

  def to_s
    description
  end

end
