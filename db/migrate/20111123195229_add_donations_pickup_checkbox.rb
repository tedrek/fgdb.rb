class AddDonationsPickupCheckbox < ActiveRecord::Migration
  def self.up
    add_column :donations, :is_pickup, :boolean, :null => false, :default => false
    Donation.reset_column_information
    found = {}
    GizmoEvent.find_all_by_gizmo_type_id(GizmoType.find_all_by_name('service_fee').first.id).map{|x| x.donation}.select{|x| !x.nil?}.each{|x|
      found[x.id] = x
    }
    # hash makes them unique: don't save a donation twice, it will be stale
    found.values.each {|x|
      x.is_pickup = true
      x.save!
    }
  end

  def self.down
    remove_column :donations, :is_pickup
  end
end
