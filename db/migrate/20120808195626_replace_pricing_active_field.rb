class ReplacePricingActiveField < ActiveRecord::Migration
  def self.up
    remove_column :pricing_values, :active
    remove_column :pricing_types, :active
    add_column :pricing_values, :ineffective_on, :datetime
    add_column :pricing_values, :replaced_by_id, :integer
    add_foreign_key :pricing_values, :replaced_by_id, :pricing_values, :id, :destroy => :restrict
    add_column :pricing_types, :ineffective_on, :datetime
    add_column :pricing_types, :replaced_by_id, :integer
    add_foreign_key :pricing_types, :replaced_by_id, :pricing_types, :id, :destroy => :restrict
  end

  def self.down
    remove_column :pricing_values, :ineffective_on
    remove_column :pricing_values, :replaced_by_id
    remove_column :pricing_types, :replaced_by_id
    remove_column :pricing_types, :ineffective_on
  end
end
