class AddNewDiscountNames < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      dn = DiscountName.find_or_create_by_description('Military')
      dn.available = true
      dn.save!

      dn = DiscountName.find_or_create_by_description('Senior')
      dn.available = true
      dn.save!

      dn2 = DiscountName.find_or_create_by_description('senior')
      dn2.available = false
      dn2.save!
      DB.exec("UPDATE sales SET discount_name_id = #{dn.id} WHERE discount_name_id = #{dn2.id};")
      dn2.destroy

      dn = DiscountName.find_or_create_by_description('Teacher')
      dn.available = false
      dn.description = 'Teacher'
      dn.save!

      dn = DiscountName.find_or_create_by_description('Student')
      dn.available = false
      dn.description = 'Student'
      dn.save!

      dn2 = DiscountName.find_or_create_by_description('student')
      dn2.available = false
      dn2.save!
      DB.exec("UPDATE sales SET discount_name_id = #{dn.id} WHERE discount_name_id = #{dn2.id};")
      dn2.destroy

      dn = DiscountName.find_or_create_by_description('STNP')
      dn.available = true
      dn.save!
    end
  end

  def self.down
  end
end
