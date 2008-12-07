class AddCashierCodes < ActiveRecord::Migration
  def self.up
    add_column "logs", "cashier_id", :integer
    ["donations", "sales", "volunteer_tasks", "disbursements", "recyclings", "contacts"].each{|x|
      add_column x, "cashier_created_by", :integer
      add_column x, "cashier_updated_by", :integer
    }
    add_column "users", "cashier_code", :integer
    User.reset_all_cashier_codes
  end

  def self.down
    remove_column "logs", "cashier_id"
    ["donations", "sales", "volunteer_tasks", "disbursements", "recyclings", "contacts"].each{|x|
      remove_column x, "cashier_created_by"
      remove_column x, "cashier_updated_by"
    }
    remove_column "users", "cashier_code"
  end
end
