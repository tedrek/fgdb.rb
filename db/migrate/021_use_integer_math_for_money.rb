class UseIntegerMathForMoney < ActiveRecord::Migration
  def self.up
#They should exist...but they don't!
#    drop_view :v_donations
#    drop_view :v_donation_totals

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
  end
end
