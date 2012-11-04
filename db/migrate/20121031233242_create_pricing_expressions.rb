class CreatePricingExpressions < ActiveRecord::Migration
  def self.up
    create_table :pricing_expressions do |t|
#      t.character :operator
      t.integer :pricing_type_id

      t.timestamps
    end

    create_table :pricing_components_pricing_expressions, :id => false do |t|
      t.integer :pricing_component_id
      t.integer :pricing_expression_id
    end

    PricingType.all.each do |t|
      PricingComponent.find_all_by_id(DB.exec("SELECT pricing_component_id FROM pricing_components_pricing_types WHERE pricing_type_id = ?", t.id).to_a.map(&:values).map(&:first).map(&:to_i)).each do |c|
        e = PricingExpression.new
        e.pricing_components << c
        e.pricing_type_id = t.id
        e.save!
      end
    end

    drop_table :pricing_components_pricing_types
  end

  def self.down
    drop_table :pricing_components_pricing_expressions
    drop_table :pricing_expressions
  end
end
