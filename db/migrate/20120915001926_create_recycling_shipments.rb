class CreateRecyclingShipments < ActiveRecord::Migration
  def self.up
    create_table :recycling_shipments do |t|
      t.integer :contact_id, :null => false
      t.string :bill_of_lading, :null => false
      t.date :received_at, :null => false
      t.date :resolved_at
      t.text :notes

      t.timestamps
    end
    add_foreign_key :recycling_shipments, :contact_id, :contacts, :id, :on_delete => :restrict
  end

  def self.down
    drop_table :recycling_shipments
  end
end
