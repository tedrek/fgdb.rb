class TurnOnCashierCodeForDisbursements < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      Default['disbursements_require_cashier_code'] = 1
    end
  end

  def self.down
  end
end
