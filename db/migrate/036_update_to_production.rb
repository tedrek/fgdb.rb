class UpdateToProduction < ActiveRecord::Migration
  def self.up
    [["gizmo_events_gizmo_typeattrs", ["gizmo_event_id"], "gizmo_events_gizmo_typeattrs_gizmo_event_id"],
     ["gizmo_events_gizmo_typeattrs", ["gizmo_typeattr_id"], "gizmo_events_gizmo_typeattrs_gizmo_typeattr_id"],
     ["recyclings", ["created_at"], "recyclings_created_at_index"],
     [:disbursements, :created_at, "disbursements_created_at_index"],
     [:sales, :contact_id, "sales_contact_id"]
    ].each do |table,column,name|
      begin
        add_index table, column, :name=>name
      rescue
      end
    end

    [[:sales, "sales_contact_id_index"],
     [:sales, "index_sales_on_contact_id"],
     [:disbursements, "dispersements_created_at_index"],
    ].each do |table, name|
      begin
        remove_index table, :name=>name
      rescue
      end
    end

    remove_foreign_key "payments", "payments_sale_txn_id_fk"
    add_foreign_key "payments", ["sale_id"], "sales", ["id"], :name => "payments_sale_txn_id_fkey"
  end 

  def self.down
  end
end
