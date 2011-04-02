class WrittenOffInvoices < ActiveRecord::Migration
  def self.up
    PaymentMethod.new(:name => "written_off_invoice", :description => "written off invoice").save!
  end

  def self.down
  end
end
