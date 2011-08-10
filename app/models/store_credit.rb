class StoreCredit < ActiveRecord::Base
  belongs_to :payment

  define_amount_methods_on :amount

  def spent?
    @spent ||= _is_spent
  end

  def spent_on
    @spent_on ||= _spent_on
  end

  def cache_shit
    spent_on
    spent?
    nil
  end

  def still_valid?(date = Date.today)
    date <= self.valid_until
  end

  def valid_until
    expire_date
  end

  def store_credit_hash
    StoreChecksum.new_from_result(self.id).checksum
  end

  def self.expire_after_value
    eval(Default["storecredit_expire_after"])
  end

#  private  ## HELPME, this breaks it.

  def _spent_on
    return payment
  end

  def my_return
    GizmoEvent.find_by_return_store_credit_id(self.id)
  end

  def is_returned
    !! self.my_return
  end

  def _is_spent
    return !(payment.nil?) || is_returned
  end
end
