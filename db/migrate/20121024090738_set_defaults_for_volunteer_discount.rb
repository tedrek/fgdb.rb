class SetDefaultsForVolunteerDiscount < ActiveRecord::Migration
  def self.up
    Default["discount_percentage_id_for_volunteer_discount"] = DiscountPercentage.find_by_percentage(20).id
    Default["discount_name_id_for_volunteer_discount"] = DiscountName.find_by_description("Volunteer").id
  end

  def self.down
  end
end
