class AddCashierToDisciplinaryActions < ActiveRecord::Migration
  def self.up
    for s in [:updated_by, :created_by, :cashier_created_by, :cashier_updated_by]
      add_column :disciplinary_actions, s, :integer
      add_foreign_key :disciplinary_actions, s, "users", "id", :on_delete => :restrict
    end
  end

  def self.down
    for s in [:updated_by, :created_by, :cashier_created_by, :cashier_updated_by]
      remove_column :disciplinary_actions, s
    end
  end
end
