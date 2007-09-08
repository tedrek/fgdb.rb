class RenameDispersementsToDisbursements < ActiveRecord::Migration
  def self.up
	rename_table :dispersements, :disbursements
	rename_column :disbursements, :dispersement_type_id, :disbursement_type_id
	rename_column :disbursements, :dispersed_at, :disbursed_at
	rename_column :gizmo_events, :dispersement_id, :disbursement_id
	rename_table :dispersement_types, :disbursement_types
    unless GizmoContext.find(:all).empty?
      dis = GizmoContext.find(4)
      dis.name = 'disbursement'
      dis.save
    end
  end

  def self.down
    rename_table :disbursements, :dispersements
    rename_column :dispersements, :disbursement_type_id, :dispersement_type_id
    rename_column :dispersements, :disbursed_at, :dispersed_at
    rename_column :gizmo_events, :disbursement_id, :dispersement_id
    rename_table :disbursement_types, :dispersement_types
    unless GizmoContext.find(:all).empty?
      dis = GizmoContext.find(4)
      dis.name = 'dispersement'
      dis.save
    end
  end
end
