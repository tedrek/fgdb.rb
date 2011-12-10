class AddReturnDisbursementId < ActiveRecord::Migration
  def self.up
    add_column :gizmo_events, :return_disbursement_id, :integer
    add_foreign_key "gizmo_events", ["return_disbursement_id"], "disbursements", ["id"], :on_delete => :restrict, :name => "gizmo_events_return_disbursement_id_fk"
  end

  def self.down
    remove_column :gizmo_events, :return_disbursement_id
    remove_foreign_key "gizmo_events", "gizmo_events_return_disbursement_id_fk"
  end
end
