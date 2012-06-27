class AddCouponDetailsToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :coupon_details, :string
  end

  def self.down
    remove_column :payments, :coupon_details
  end
end
