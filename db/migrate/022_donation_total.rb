class DonationTotal < ActiveRecord::Migration
  def self.up
    create_view( :v_donation_totals,
                 "select d.id, sum(p.amount_dollars + (p.amount_cents/100.0)) from donations as d " +
                 "left outer join payments as p on p.donation_id = d.id " +
                 "group by d.id" ) do |t|
      t.column :id
      t.column :total_paid
    end

    create_view( :v_donations, "select d.*, v.total_paid, " +
                 "CASE WHEN (v.total_paid > (d.reported_required_fee_dollars + (d.reported_required_fee_cents/100.0))) THEN (d.reported_required_fee_dollars+(reported_required_fee_cents/100.0)) ELSE v.total_paid END, " +
                 "CASE WHEN (v.total_paid < (d.reported_required_fee_dollars+(reported_required_fee_cents/100.0))) THEN 0.00 " +
                 "ELSE (v.total_paid - (d.reported_required_fee_dollars+(reported_required_fee_cents/100.0))) END " +
                 "from donations as d join v_donation_totals as v on d.id = v.id" ) do |t|
      t.column "id"
      t.column "contact_id"
      t.column "postal_code"
      t.column "txn_complete"
      t.column "txn_completed_at"
      t.column "comments"
      t.column "lock_version"
      t.column "updated_at"
      t.column "created_at"
      t.column "created_by"
      t.column "updated_by"
      t.column "reported_required_fee_dollars"
      t.column "reported_required_fee_cents"
      t.column "reported_suggested_fee_dollars"
      t.column "reported_suggested_fee_cents"
      t.column "total_paid"
      t.column "fees_paid"
      t.column "donations_paid"
    end
  end

  def self.down
    drop_view :v_donations
    drop_view :v_donation_totals
  end
end
