class AddReturnStorecredit < ActiveRecord::Migration
  def self.up
    add_column :gizmo_events, :return_store_credit_id, :integer
    add_foreign_key :gizmo_events, :return_store_credit_id, :store_credits, :id, :on_delete => :restrict
  end

  def self.down
    remove_column :gizmo_events, :return_store_credit_id
  end
end
