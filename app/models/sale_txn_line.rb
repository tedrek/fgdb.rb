require 'ajax_scaffold'

class SaleTxnLine < ActiveRecord::Base
  belongs_to :sale_txn
  belongs_to :forsale_item
  validates_associated :forsale_item
  #validates_presence_of :forsale_item

  def to_s
    "Net $ #{net_price}"
  end

end
