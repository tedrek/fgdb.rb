require 'ajax_scaffold'

class SaleTxn < ActiveRecord::Base
  belongs_to :contact
  validates_associated :contact
  belongs_to :payment_method
  validates_associated :payment_method
  belongs_to :till_handler
  validates_associated :till_handler
  has_many :sale_txn_lines

  def to_s
    "id: $ #{net_amount}"
  end

end
