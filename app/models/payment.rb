class Payment < ActiveRecord::Base
  belongs_to :donation
  belongs_to :sale
  belongs_to :payment_method
  belongs_to :store_credit

  validates_presence_of :payment_method_id

  define_amount_methods_on("amount")

  def mostly_empty?
    # Allow negative payments (e.g. credits)
    #  http://svn.freegeek.org/projects/fgdb.rb/ticket/224
    ! ( valid? && amount_cents && (amount_cents != 0) )
  end

  def to_s
    "$%d.%02d %s" % [amount_cents/100, amount_cents%100, payment_method.description]
  end
end
