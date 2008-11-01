class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.string :name # the contracts name, as referred to in code.
      t.string :description # the contracts name, as shown in donations.
      t.string :label # the name of the label put on these computers, as shown on printmes, disbursements, sales, and recyclings. NULL if shouldn't be tracked specially with these transactions.
      t.text :notes # the notes to be shown to the person entering in donations that came through this contract

      t.timestamps
    end

    c = Contract.new
    c.label = "keeper"
    c.name = "default"
    c.description = "normal"
    c.save!

    add_column "systems", "contract_id", :integer, :default => c.id, :null => false
    add_foreign_key "systems", "contract_id", "contracts", "id", :on_delete => :restrict

    add_column "donations", "contract_id", :integer, :default => c.id, :null => false
    add_foreign_key "donations", "contract_id", "contracts", "id", :on_delete => :restrict

    add_column "gizmo_events", "recycling_contract_id", :integer
    add_foreign_key "gizmo_events", "recycling_contract_id", "contracts", "id", :on_delete => :restrict
    GizmoEvent.connection.execute("UPDATE gizmo_events SET recycling_contract_id = #{c.id} WHERE recycling_id IS NOT NULL;")

    add_column "contacts", "contract_id", :integer, :default => c.id, :null => false
    add_foreign_key "contacts", "contract_id", "contracts", "id", :on_delete => :restrict
  end

  def self.down
    drop_table :contracts
    remove_column "systems", "contract_id"
    remove_column "gizmo_events", "recycling_contract_id"
    remove_column "donations", "contract_id"
    remove_column "contacts", "contract_id"
  end
end
