class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.string :label
      t.string :name
      t.string :description
      t.timestamps
    end

    c = Contract.new
    c.label = "keeper"
    c.name = "default"
    c.description = "normal"
    c.save!

    add_column "spec_sheets", "contract_id", :integer, :default => c.id, :null => false
    add_foreign_key "spec_sheets", "contract_id", "contracts", "id", :on_delete => :restrict
  end

  def self.down
    drop_table :contracts
    remove_column "spec_sheets", "contract_id"
  end
end
