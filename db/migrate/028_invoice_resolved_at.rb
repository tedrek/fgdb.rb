class InvoiceResolvedAt < ActiveRecord::Migration
  def self.up
    add_column 'sales', 'invoice_resolved_at', :datetime
    add_column 'donations', 'invoice_resolved_at', :datetime
  end

  def self.down
    remove_column 'sales', 'invoice_resolved_at'
    remove_column 'donations', 'invoice_resolved_at'
  end
end
