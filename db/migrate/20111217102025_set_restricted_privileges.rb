class SetRestrictedPrivileges < ActiveRecord::Migration
  def self.up
    for i in %w(create_donations view_donations change_donations create_sales view_sales change_sales create_disbursements view_disbursements change_disbursements create_gizmo_returns change_gizmo_returns view_gizmo_returns create_recyclings view_recyclings change_recyclings manage_contacts manage_volunteer_hours role_contact_manager role_store role_front_desk role_tech_support schedule_volunteers sign_off_spec_sheets issue_store_credit view_volunteer_schedule )
      p = Privilege.find_by_name(i)
      p.restrict = false
      p.save!
    end
  end

  def self.down
  end
end
