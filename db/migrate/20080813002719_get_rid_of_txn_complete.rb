class GetRidOfTxnComplete < ActiveRecord::Migration
  def self.up
    Donation.connection.execute("DROP VIEW v_donations")
    Donation.connection.execute("DROP VIEW v_donation_totals")

    remove_column "sales", "txn_complete"
    remove_column "sales", "txn_completed_at"
    remove_column "donations", "txn_complete"
    remove_column "donations", "txn_completed_at"
  end

  def self.down
  end
end
