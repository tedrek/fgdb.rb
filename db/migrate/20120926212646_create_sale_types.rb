class CreateSaleTypes < ActiveRecord::Migration
  def self.up
    create_table :sale_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    add_column :discount_schedules, :instantiable, :boolean, :default => true, :null => false

    ds = DiscountSchedule.find_by_name("bulk")
    ds.instantiable = false
    ds.save!

    h = OH.new
    h[:retail] = "Retail"
    h[:online] = "Online"
    h[:bulk] = "Bulk"
    h[:other] = "Other"

    r = {}

    h.each do |k,v|
      st = SaleType.new(:name => k.to_s, :description => v)
      st.save!
      r[k] = st.id
    end

    add_column :sales, :sale_type_id, :integer, :null => false, :default => r[:retail]
    add_foreign_key :sales, :sale_type_id, :sale_types, :id

    DB.exec("UPDATE sales SET sale_type_id = #{r[:online]} WHERE online = 't';")
    DB.exec("UPDATE sales SET sale_type_id = #{r[:bulk]} WHERE bulk = 't';")

    bulk_id = ContactType.find_by_name("bulk_buyer").id

    DB.exec("UPDATE sales SET sale_type_id = #{r[:bulk]} WHERE contact_id IS NOT NULL AND contact_id IN (SELECT contact_id FROM contact_types_contacts WHERE contact_types_contacts.contact_id = sales.contact_id AND contact_type_id = #{bulk_id});")
    DB.exec("UPDATE sales SET sale_type_id = #{r[:bulk]} WHERE discount_schedule_id = #{ds.id};")

    remove_column :sales, :online
    remove_column :sales, :bulk
  end

  def self.down
    drop_table :sale_types
  end
end
