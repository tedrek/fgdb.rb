class UseIntegerMathForMoney < ActiveRecord::Migration
  def self.up
    drop_view :v_donations
    drop_view :v_donation_totals

    add_column "donations", :reported_required_fee_dollars, :int
    add_column "donations", :reported_required_fee_cents, :int
    execute "UPDATE donations SET reported_required_fee_cents = trunc((reported_required_fee % 1) * 100)"
    execute "UPDATE donations SET reported_required_fee_dollars = trunc(reported_required_fee)"
    remove_column "donations", :reported_required_fee

    add_column "donations", :reported_suggested_fee_dollars, :int
    add_column "donations", :reported_suggested_fee_cents, :int
    execute "UPDATE donations SET reported_suggested_fee_cents = trunc((reported_suggested_fee % 1) * 100)"
    execute "UPDATE donations SET reported_suggested_fee_dollars = trunc(reported_suggested_fee)"
    remove_column "donations", :reported_suggested_fee

    add_column "payments", :amount_dollars, :int
    add_column "payments", :amount_cents, :int
    execute "UPDATE payments SET amount_cents = trunc((amount % 1) * 100)"
    execute "UPDATE payments SET amount_dollars = trunc(amount)"
    remove_column "payments", :amount

    add_column "gizmo_types", :required_fee_dollars, :int
    add_column "gizmo_types", :required_fee_cents, :int
    execute "UPDATE gizmo_types SET required_fee_cents = trunc((required_fee % 1) * 100)"
    execute "UPDATE gizmo_types SET required_fee_dollars = trunc(required_fee)"
    remove_column "gizmo_types", :required_fee

    add_column "gizmo_types", :suggested_fee_dollars, :int
    add_column "gizmo_types", :suggested_fee_cents, :int
    execute "UPDATE gizmo_types SET suggested_fee_cents = trunc((suggested_fee % 1) * 100)"
    execute "UPDATE gizmo_types SET suggested_fee_dollars = trunc(suggested_fee)"
    remove_column "gizmo_types", :suggested_fee

    add_column "gizmo_events_gizmo_typeattrs", :attr_val_monetary_dollars, :int
    add_column "gizmo_events_gizmo_typeattrs", :attr_val_monetary_cents, :int
    execute "UPDATE gizmo_events_gizmo_typeattrs SET attr_val_monetary_cents = trunc((attr_val_monetary % 1) * 100)"
    execute "UPDATE gizmo_events_gizmo_typeattrs SET attr_val_monetary_dollars = trunc(attr_val_monetary)"
    remove_column "gizmo_events_gizmo_typeattrs", :attr_val_monetary

    add_column "sales", :reported_discount_amount_dollars, :int
    add_column "sales", :reported_discount_amount_cents, :int
    execute "UPDATE sales SET reported_discount_amount_cents = trunc((reported_discount_amount % 1) * 100)"
    execute "UPDATE sales SET reported_discount_amount_dollars = trunc(reported_discount_amount)"
    remove_column "sales", :reported_discount_amount

    add_column "sales", :reported_amount_due_dollars, :int
    add_column "sales", :reported_amount_due_cents, :int
    execute "UPDATE sales SET reported_amount_due_cents = trunc((reported_amount_due % 1) * 100)"
    execute "UPDATE sales SET reported_amount_due_dollars = trunc(reported_amount_due)"
    remove_column "sales", :reported_amount_due
  end

  def self.down
    add_column "donations", :reported_required_fee, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE donations SET reported_required_fee = reported_required_fee_dollars + (reported_required_fee_cents/100.0)"
    remove_column "donations", :reported_required_fee_dollars
    remove_column "donations", :reported_required_fee_cents

    add_column "donations", :reported_suggested_fee, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE donations SET reported_suggested_fee = reported_suggested_fee_dollars + (reported_suggested_fee_cents/100.0)"
    remove_column "donations", :reported_suggested_fee_dollars
    remove_column "donations", :reported_suggested_fee_cents

    add_column "payments", :amount, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE payments SET amount = amount_dollars + (amount_cents/100.0)"
    remove_column "payments", :amount_dollars
    remove_column "payments", :amount_cents

    add_column "gizmo_types", :required_fee, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE gizmo_types SET required_fee = required_fee_dollars + (required_fee_cents/100.0)"
    remove_column "gizmo_types", :required_fee_dollars
    remove_column "gizmo_types", :required_fee_cents

    add_column "gizmo_types", :suggested_fee, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE gizmo_types SET suggested_fee = suggested_fee_dollars + (suggested_fee_cents/100.0)"
    remove_column "gizmo_types", :suggested_fee_dollars
    remove_column "gizmo_types", :suggested_fee_cents

    add_column "gizmo_events_gizmo_typeattrs", :attr_val_monetary, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE gizmo_events_gizmo_typeattrs SET attr_val_monetary = attr_val_monetary_dollars + (attr_val_monetary_cents/100.0)"
    remove_column "gizmo_events_gizmo_typeattrs", :attr_val_monetary_dollars
    remove_column "gizmo_events_gizmo_typeattrs", :attr_val_monetary_cents

    add_column "sales", :reported_discount_amount, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE sales SET reported_discount_amount = reported_discount_amount_dollars + (reported_discount_amount_cents/100.0)"
    remove_column "sales", :reported_discount_amount_dollars
    remove_column "sales", :reported_discount_amount_cents

    add_column "sales", :reported_amount_due, :decimal, :precision => 10, :scale => 2, :default => 0.0
    execute "UPDATE sales SET reported_amount_due = reported_amount_due_dollars + (reported_amount_due_cents/100.0)"
    remove_column "sales", :reported_amount_due_dollars
    remove_column "sales", :reported_amount_due_cents
    create_view( :v_donation_totals,
                 "select d.id, sum(p.amount) from donations as d " +
                 "left outer join payments as p on p.donation_id = d.id " +
                 "group by d.id" ) do |t|
      t.column :id
      t.column :total_paid
    end

    create_view( :v_donations, "select d.*, v.total_paid, " +
                 "CASE WHEN (v.total_paid > d.reported_required_fee) THEN d.reported_required_fee ELSE v.total_paid END, " +
                 "CASE WHEN (v.total_paid < d.reported_required_fee) THEN 0.00 " +
                 "ELSE (v.total_paid - d.reported_required_fee) END " +
                 "from donations as d join v_donation_totals as v on d.id = v.id" ) do |t|
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
      t.column "fees_paid"
      t.column "donations_paid"
    end
  end
end
