module SidebarHelper
  # TODO: add methods like this that control it for all 4 transactions + hours, reports, and contact dedup
  # TODO: get this from some table or something

  def should_show_library
    true
  end

  def should_show_fgss
    true
  end

  def should_show_schedule
    true
  end

  def should_show_edit_schedule
    true
  end

  def controller_to_section
    {"recyclings" => "recyclings",
    "volunteer_tasks" => "hours",
    "sales" => "sales",
    "donations" => "donations",
    "disbursements" => "disbursements",
    "reports" => "reports",
    "graphic_reports" => "reports",
    "work_shifts" => "staff schedule",
    "contacts" => "contacts",
    "contact_duplicates" => "contacts",
#    "library" => "library",
    "spec_sheets" => "fgss",
    "gizmo_returns" => "returns",
    "till_adjustments" => "bean counters",
    "worked_shifts" => "staff",
    "points_trades" => "hours"}
  end

  def sidebar_stuff
    # base
    aliases = {:a => :action, :c => :controller}
    sidebar_hash = OH.n
    sidebar_hash.default_class = OH
    # hours
    if has_privileges("role_volunteer_manager")
      sidebar_hash["hours"]["entry"] = {:c => "volunteer_tasks"}
      sidebar_hash["hours"]["points trade"] = {:c => 'points_trades'}
    elsif current_user and current_user.contact_id
      sidebar_hash["hours"]["entry"] = {:c => "volunteer_tasks", :contact_id => current_user.contact_id}
    end
    # transactions
    {:donation => ["role_front_desk"], :sale => ["role_store"], :recycling => ["role_front_desk", "role_recyclings"], :disbursement => ['role_contact_manager', 'role_front_desk', 'role_store', 'role_volunteer_manager'], :gizmo_return => ['role_store', 'role_tech_support']}.each do |i,x|
      if x.nil? || has_privileges(*x)
        pl = i.to_s.pluralize
        disp = pl.sub("gizmo_", "")
        sidebar_hash[disp]["entry"] = {:c => pl}
        sidebar_hash[disp]["search"] = {:c => pl, :a => 'search'}
      end
    end
    # reports
    ["income", "gizmos", "volunteering"].each do |x|
      sidebar_hash["reports"][x] = {:c => "reports", :a => x.sub("ing", "s")}
    end
    sidebar_hash["reports"]["trends"] = {:c => 'graphic_reports'}
    # contacts
    sidebar_hash["contacts"]["contacts"] = {:c => "contacts"} if has_privileges('role_contact_manager', 'role_front_desk', 'role_store', 'role_volunteer_manager')
    sidebar_hash["contacts"]["dedup"] = {:c => 'contact_duplicates'} if has_privileges('role_contact_manager')
    sidebar_hash["contacts"]["duplicates list"] = {:c => 'contact_duplicates', :a => "list_dups"} if has_privileges('role_contact_manager')
    # bean counters
    sidebar_hash["bean counters"]["till adjustments"] = {:c => "till_adjustments"} if has_privileges('role_bean_counter')
    # staffsched
    sidebar_hash["staff"]["schedule"] = "/staffsched" if should_show_schedule
    sidebar_hash["staff"]["edit schedule"] = {:c => "work_shifts"} if should_show_edit_schedule and has_privileges('role_skedjulnator')
    sidebar_hash["staff"]["staff hours"] = {:c => "worked_shifts"} if has_privileges('staff')
    sidebar_hash["staff"]["individual report"] = {:c => "worked_shifts", :a => "individual"} if has_privileges('staff')
    sidebar_hash["staff"]["jobs report"] = {:c => "reports", :a => "staff_hours"} if has_privileges('staff')
    sidebar_hash["staff"]["types report"] = {:c => "worked_shifts", :a => "type_totals"} if has_privileges('role_skedjulnator', 'role_bean_counter')
    sidebar_hash["staff"]["payroll report"] = {:c => "worked_shifts", :a => "payroll"} if has_privileges('role_skedjulnator', 'role_bean_counter')
    sidebar_hash["staff"]["weekly report"] = {:c => "worked_shifts", :a => "weekly_workers"} if has_privileges('role_skedjulnator', 'role_bean_counter')
    # library
#    requires_librarian = ['overdue', 'labels', 'cataloging', 'borrowers', 'inventory']
#    for i in ['lookup', 'overdue', 'inventory', 'cataloging', 'search', 'labels', 'borrowers'] do
#      if !requires_librarian.include?(i) or has_privileges("LIBRARIAN")
#        sidebar_hash["library"][i] = {:c => "library", :a => i}
#      end
#    end
    # fgss
    sidebar_hash["fgss"]["printme"] = {:c => 'spec_sheets'}
    sidebar_hash["fgss"]["fix contract"] = {:c => 'spec_sheets', :a => "fix_contract"} if contract_enabled && has_privileges("role_admin")
    # done
    return aliases, sidebar_hash
  end
end
