class AddGizmoEventMetadataForInvoices < ActiveRecord::Migration
  def self.up
    add_column :gizmo_events, :invoice_donation_id, :integer
    if Default.is_pdx
      GizmoType.new(:description => "Invoice Resolved", :required_fee_cents => 0, :suggested_fee_cents => 0, :gizmo_category => GizmoCategory.find_by_name('misc'), :name => "invoice_resolved", :covered => false, :rank => 99, :parent_name => nil, :needs_id => false, :return_policy_id => nil, :gizmo_contexts => [GizmoContext.donation]).save!
    end
  end

  def self.down
    remove_column :gizmo_events, :invoice_donation_id
    if Default.is_pdx
      GizmoType.find_by_name("invoice_resolved").destroy
    end
  end
end
