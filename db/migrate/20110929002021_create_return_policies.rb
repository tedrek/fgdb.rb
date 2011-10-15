class CreateReturnPolicies < ActiveRecord::Migration
  def self.up
    create_table :return_policies do |t|
      t.string :name
      t.string :description
      t.text :text

      t.timestamps
    end
    add_column :gizmo_types, :return_policy_id, :integer
    add_foreign_key :gizmo_types, :return_policy_id, :return_policies, :id
  end

  def self.down
    drop_table :return_policies
  end
end
