class Payment < ActiveRecord::Base

  belongs_to :donation
  belongs_to :sale
  belongs_to :payment_method

  validates_presence_of :payment_method_id

  define_amount_methods_on("amount")

  def mostly_empty?
    # Allow negative payments (e.g. credits)
    #  http://svn.freegeek.org/projects/fgdb.rb/ticket/224
    ! ( valid? && amount && (amount != 0) )
  end

  def to_s
    "$%0.2f %s" % [amount, payment_method.description]
  end
end
