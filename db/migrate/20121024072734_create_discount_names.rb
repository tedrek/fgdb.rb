class CreateDiscountNames < ActiveRecord::Migration
  def self.up
    create_table :discount_names do |t|
      t.string :description
      t.boolean :available

      t.timestamps
    end
    DiscountName.new(:description => "Old Coupon", :available => false).save
    DiscountName.new(:description => "Old Bulk", :available => false).save
    DiscountName.new(:description => "Old One Time", :available => false).save
    DiscountName.new(:description => "None", :available => true).save
    DiscountName.new(:description => "Volunteer", :available => true).save
    DiscountName.new(:description => "Donor", :available => true).save
    DiscountName.new(:description => "Friend", :available => true).save
    DiscountName.new(:description => "Chinook", :available => true).save
    DiscountName.new(:description => "Student", :available => true).save
    DiscountName.new(:description => "Grants", :available => true).save
  end

  def self.down
    drop_table :discount_names
  end
end
