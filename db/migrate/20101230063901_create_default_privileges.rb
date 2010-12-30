class CreateDefaultPrivileges < ActiveRecord::Migration
  def self.up
    arr = [
           ["skedjulnator", "role_skedjulnator"],

           ["create_donations", "role_front_desk"],
           ["view_donations", "role_front_desk"],
           ["change_donations", "role_donation_admin", "role_bean_counter"],

           ["create_sales", "role_store"],
           ["view_sales", "role_store", "role_tech_support"],
           ["change_sales", "role_store_admin", "role_bean_counter"],

           ["create_disbursements", "role_contact_manager", "role_front_desk", "role_store", "role_volunteer_manager", "role_tech_support"],
           ["view_disbursements", "role_contact_manager", "role_front_desk", "role_store", "role_volunteer_manager", "role_tech_support"],
           ["change_disbursements", "role_bean_counter"],

           ["create_gizmo_returns", "role_store", "role_tech_support"],
           ["view_gizmo_returns", "role_store", "role_tech_support"],
           ["change_gizmo_returns", "role_store_admin", "role_bean_counter"],

           ["create_recyclings", "role_recyclings", "role_front_desk"],
           ["view_recyclings", "role_recyclings", "role_front_desk"],
           ["change_recyclings", "role_bean_counter"],

           ["manage_contacts", 'role_contact_manager'],
           ["manage_workers", 'role_skedjulnator', "role_bean_counter"],
           ["manage_volunteer_hours", "role_volunteer_manager"],
           ["till_adjustments", "role_bean_counter"],
          ]
    arr.each{|a|
      pn = a.shift
      p = Privilege.new
      p.name = pn
      pr = a.map{|x| x.gsub(/^role_/, "").upcase}
      p.roles = pr.map{|x| Role.find_by_name(x)}
#      puts "#{pn}: #{pr.join(", ")}"
      p.save
    }

    r = Role.find_by_name("CONTACT_MANAGER")
    bp = Privilege.by_name(r.to_privileges)
    bp.save

    r = Role.find_by_name("VOLUNTEER_MANAGER")
    r.privileges << bp
    r.save

    r = Role.find_by_name("STORE")
    r.privileges << bp
    r.save
    p = Privilege.by_name(r.to_privileges)

    r = Role.find_by_name("BEAN_COUNTER")
    r.privileges << p
    r.save

    r = Role.find_by_name("STORE_ADMIN")
    r.privileges << p
    r.save

    r = Role.find_by_name("FRONT_DESK")
    r.privileges << bp
    r.save
    p = Privilege.by_name(r.to_privileges)

    r = Role.find_by_name("DONATION_ADMIN")
    r.privileges << p
    r.save

    r = Role.find_by_name("BEAN_COUNTER")
    r.privileges << p
    r.save

    r = Role.find_by_name("TECH_SUPPORT")
    r.privileges << bp
    r.save
    p = Privilege.by_name(r.to_privileges)

    r = Role.find_by_name("BEAN_COUNTER")
    r.privileges << p
    r.save
  end

  def self.down
    Privilege.destroy_all
  end
end
