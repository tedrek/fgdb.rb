class MovePricingTypeLinkToTypes < ActiveRecord::Migration
  def self.up
    remove_column :pricing_types, :type_id
    add_column :types, :pricing_type_id, :integer
    add_foreign_key :types, :pricing_type_id, :pricing_types, :id, :on_delete => :restrict
  end

  def self.down
  end
end
