class MovePricingTypeLinkToTypes < ActiveRecord::Migration
  def self.up
    remove_column :pricing_types, :type_id
#    remove_column :types, :pricing_type_id
    create_table :pricing_types_types, :id => false do |t|
      t.integer :type_id
      t.integer :pricing_type_id
    end
    add_foreign_key :pricing_types_types, :type_id, :types, :id, :on_delete => :cascade
    add_foreign_key :pricing_types_types, :pricing_type_id, :pricing_types, :id, :on_delete => :cascade
  end

  def self.down
  end
end
