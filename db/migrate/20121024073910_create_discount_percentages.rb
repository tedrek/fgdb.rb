class CreateDiscountPercentages < ActiveRecord::Migration
  def self.up
    create_table :discount_percentages do |t|
      t.integer :percentage
      t.boolean :available

      t.timestamps
    end
    DiscountPercentage.new(:percentage => 0, :available => true).save!
    DiscountPercentage.new(:percentage => 5, :available => false).save!
    DiscountPercentage.new(:percentage => 10, :available => true).save!
    DiscountPercentage.new(:percentage => 15, :available => true).save!
    DiscountPercentage.new(:percentage => 20, :available => true).save!
    DiscountPercentage.new(:percentage => 25, :available => true).save!
    DiscountPercentage.new(:percentage => 30, :available => true).save!
    DiscountPercentage.new(:percentage => 35, :available => true).save!
    DiscountPercentage.new(:percentage => 50, :available => false).save!
  end

  def self.down
    drop_table :discount_percentages
  end
end
