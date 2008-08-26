class ButBackViews < ActiveRecord::Migration
  def self.up
    create_view "v_donation_totals", "SELECT d.id, sum(p.amount_cents) AS total_paid FROM (donations d LEFT JOIN payments p ON ((p.donation_id = d.id))) GROUP BY d.id;", :force => true do |v|
      v.column :id
      v.column :total_paid
    end

    create_view "v_donations", "SELECT d.id, d.contact_id, d.postal_code,d.comments, d.lock_version, d.updated_at, d.created_at, d.created_by, d.updated_by, d.reported_required_fee_cents, d.reported_suggested_fee_cents, v.total_paid, CASE WHEN (v.total_paid > d.reported_required_fee_cents) THEN (d.reported_required_fee_cents)::bigint ELSE v.total_paid END AS fees_paid, CASE WHEN (v.total_paid < d.reported_required_fee_cents) THEN (0)::bigint ELSE (v.total_paid - d.reported_required_fee_cents) END AS donations_paid FROM (donations d JOIN v_donation_totals v ON ((d.id = v.id)));", :force => true do |v|
      v.column :id
      v.column :contact_id
      v.column :postal_code
      v.column :comments
      v.column :lock_version
      v.column :updated_at
      v.column :created_at
      v.column :created_by
      v.column :updated_by
      v.column :reported_required_fee_cents
      v.column :reported_suggested_fee_cents
      v.column :total_paid
      v.column :fees_paid
      v.column :donations_paid
    end
  end

  def self.down
  end
end
