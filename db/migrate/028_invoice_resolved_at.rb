class InvoiceResolvedAt < ActiveRecord::Migration
  def self.up
    add_column 'sales', 'invoice_resolved_at', :datetime
    add_column 'donations', 'invoice_resolved_at', :datetime
    Sale.connection.execute("UPDATE sales SET invoice_resolved_at = created_at WHERE created_at < '2008-01-01'")
    Donation.connection.execute("UPDATE donations SET invoice_resolved_at = created_at WHERE created_at < '2008-01-01'")
  end

  def self.down
    remove_column 'sales', 'invoice_resolved_at'
    remove_column 'donations', 'invoice_resolved_at'
  end
end
