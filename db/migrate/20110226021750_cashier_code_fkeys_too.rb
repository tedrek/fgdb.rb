class CashierCodeFkeysToo < ActiveRecord::Migration
  def self.up
    ["donations", "sales", "volunteer_tasks", "disbursements", "recyclings", "contacts", "gizmo_returns"].each{|x|
      add_foreign_key x, "cashier_created_by", "users", "id", :on_delete => :restrict
      add_foreign_key x, "cashier_updated_by", "users", "id", :on_delete => :restrict
    }
  end

  def self.down
  end
end
