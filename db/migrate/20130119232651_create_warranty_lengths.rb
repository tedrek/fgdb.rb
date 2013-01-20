class CreateWarrantyLengths < ActiveRecord::Migration
  def self.up
    create_table :warranty_lengths do |t|
      t.string :system_type, :null => false
      t.string :box_source, :null => false
      t.string :os_type
      t.string :length, :null => false
      t.date :effecitve_on
      t.date :ineffective_on

      t.timestamps
    end
    WarrantyLength.new(:system_type => 'Desktop', :box_source => 'Build', :length => '1.year').create
    WarrantyLength.new(:system_type => 'Desktop', :box_source => 'Adoption', :length => '1.year').create
    WarrantyLength.new(:system_type => 'Desktop', :box_source => 'HW Grants', :length => '1.year').create
    WarrantyLength.new(:system_type => 'Desktop', :box_source => 'Store', :length => '6.months').create
    WarrantyLength.new(:system_type => 'Laptop', :box_source => 'HW Grants', :length => '6.months').create
    WarrantyLength.new(:system_type => 'Laptop', :box_source => 'Store', :length => '6.months').create
    WarrantyLength.new(:system_type => 'Servers', :box_source => 'HW Grants', :length => '14.days').create
    WarrantyLength.new(:system_type => 'Servers', :box_source => 'Store', :length => '14.days').create
    WarrantyLength.new(:system_type => 'Mac Desktop', :box_source => 'HW Grants', :os_type => 'Linux', :length => '6.months').create
    WarrantyLength.new(:system_type => 'Mac Desktop', :box_source => 'HW Grants', :os_type => 'Mac', :length => '90.days').create
    WarrantyLength.new(:system_type => 'Mac Desktop', :box_source => 'Store', :os_type => 'Linux', :length => '6.months').create
    WarrantyLength.new(:system_type => 'Mac Desktop', :box_source => 'Store', :os_type => 'Mac', :length => '90.days').create
    WarrantyLength.new(:system_type => 'Mac Laptop', :box_source => 'HW Grants', :os_type => 'Linux', :length => '6.months').create
    WarrantyLength.new(:system_type => 'Mac Laptop', :box_source => 'HW Grants', :os_type => 'Mac', :length => '90.days').create
    WarrantyLength.new(:system_type => 'Mac Laptop', :box_source => 'Store', :os_type => 'Linux', :length => '6.months').create
    WarrantyLength.new(:system_type => 'Mac Laptop', :box_source => 'Store', :os_type => 'Mac', :length => '90.days').create
  end

  def self.down
    drop_table :warranty_lengths
  end
end
