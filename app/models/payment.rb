class Payment < ActiveRecord::Base
  belongs_to :donation
  belongs_to :sale
  belongs_to :payment_method

  validates_presence_of :payment_method_id

  def mostly_empty?
    ! ( valid? && amount && (amount > 0) )
  end

  def to_s
    "$%0.2f %s" % [amount, payment_method.description]
  end
end
