class SaleToSaleTxn < ActiveRecord::Migration
  def self.up
    rename_column :payments, :sale_txn_id, :sale_id
    rename_column :gizmo_events, :sale_txn_id, :sale_id
    rename_table :sale_txns, :sales
  end

  def self.down
    rename_column :payments, :sale_id, :sale_txn_id
    rename_column :gizmo_events, :sale_id, :sale_txn_id
    rename_table :sales, :sale_txns
  end
end
