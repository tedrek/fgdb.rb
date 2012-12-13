class AddRawReceiptAccountRegexp < ActiveRecord::Migration
  def self.up
    Default['raw_receipt_account_regexp'] = 'store'
  end

  def self.down
  end
end
