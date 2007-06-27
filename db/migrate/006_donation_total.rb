class DonationTotal < ActiveRecord::Migration
  def self.up
    create_view( :v_donation_totals,
                 "select d.id, sum(p.amount) from donations as d " +
                 "left outer join payments as p on p.donation_id = d.id " +
                 "group by d.id" ) do |t|
      t.column :id
      t.column :total_paid
    end
    create_view :v_donations, "select d.*, v.total_paid from donations as d join v_donation_totals as v on d.id = v.id" do |t|
      t.column "id"
      t.column "contact_id"
      t.column "postal_code"
      t.column "reported_required_fee"
      t.column "reported_suggested_fee"
      t.column "txn_complete"
      t.column "txn_completed_at"
      t.column "comments"
      t.column "lock_version"
      t.column "updated_at"
      t.column "created_at"
      t.column "created_by"
      t.column "updated_by"
      t.column "total_paid"
    end
  end

  def self.down
    drop_view :v_donations
    drop_view :v_donation_totals
  end
end
