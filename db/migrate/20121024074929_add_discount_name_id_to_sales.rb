class AddDiscountNameIdToSales < ActiveRecord::Migration
  def self.up
    add_column :sales, :discount_name_id, :integer, :null => false, :default => DiscountName.find_by_description("None").id
    add_foreign_key :sales, :discount_name_id, :discount_names, :id, :on_delete => :restrict

    discount_name_map = {
      "no_discount" => "None",
      "volunteer" => "Volunteer",
      "friend" => "Friend",
      "coupon" => "Old Coupon",
      "one_time" => "Old One Time",
      "bulk" => "Old Bulk"}

    discount_schedule_map = {}
    discount_name_map.each do |k, v|
      discount_schedule_map[DiscountSchedule.find_by_name(k).id] = DiscountName.find_by_description(v).id
    end

    discount_schedule_map.each do |k, v|
      DB.exec("UPDATE sales SET discount_name_id = #{v} WHERE discount_schedule_id = #{k};")
    end
  end

  def self.down
  end
end
