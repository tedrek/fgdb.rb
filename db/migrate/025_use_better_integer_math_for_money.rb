class UseBetterIntegerMathForMoney < ActiveRecord::Migration
  def self.up
#    drop_view :v_donations
#    drop_view :v_donation_totals

    define_up_on("donations", "reported_required_fee")
    define_up_on("donations", "reported_suggested_fee")
    define_up_on("payments", "amount")
    define_up_on("gizmo_types", "required_fee")
    define_up_on("gizmo_types", "suggested_fee")
    define_up_on("gizmo_events_gizmo_typeattrs", "attr_val_monetary")
    define_up_on("sales", "reported_discount_amount")
    define_up_on("sales", "reported_amount_due")

    add_column("gizmo_events", :adjusted_fee_cents, :int)
    execute "UPDATE gizmo_events SET adjusted_fee_cents=trunc(adjusted_fee*100)"
    remove_column("gizmo_events", :adjusted_fee)
  end

  def self.down
    define_down_on("donations", "reported_required_fee")
    define_down_on("donations", "reported_suggested_fee")
    define_down_on("payments", "amount")
    define_down_on("gizmo_types", "required_fee")
    define_down_on("gizmo_types", "suggested_fee")
    define_down_on("gizmo_events_gizmo_typeattrs", "attr_val_monetary")
    define_down_on("sales", "reported_discount_amount")
    define_down_on("sales", "reported_amount_due")
    
    add_column("gizmo_events", :adjusted_fee, :float)
    execute "UPDATE gizmo_events SET adjusted_fee=adjusted_fee_cents/100.0"
    remove_column("gizmo_events", :adjusted_fee_cents)

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

  def self.define_up_on(table_name, column_name)
    code = "execute \"UPDATE #{table_name} SET #{column_name}_cents = #{column_name}_cents+(#{column_name}_dollars*100)\"
    remove_column \"#{table_name}\", :#{column_name}_dollars"
    self.module_eval(code)
  end

  def self.define_down_on(table_name, column_name)
    code = "add_column \"#{table_name}\", :#{column_name}_dollars, :int
    execute \"UPDATE #{table_name} SET #{column_name}_dollars = trunc(#{column_name}_cents/100.0)\"
    execute \"UPDATE #{table_name} SET #{column_name}_cents = ((#{column_name}_cents/100.0)%1)*100\""
    self.module_eval(code)
  end
end
