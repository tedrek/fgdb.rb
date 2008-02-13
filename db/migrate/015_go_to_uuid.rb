class GoToUuid < ActiveRecord::Migration
  @@table_counter = 0
  @@counted_tables = {}

  def self.fix_specials(conn)
    ["ALTER INDEX dispersements_pkey RENAME TO disbursements_pkey",
     "ALTER TABLE disbursements DROP CONSTRAINT dispersements_pkey CASCADE",
     "ALTER INDEX dispersement_types_pkey RENAME TO disbursements_types_pkey",
     "DROP INDEX contact_types_contacts_contact_id_key",
     "DROP VIEW v_donations",
     "DROP VIEW v_donation_totals",
    ].each {|stmt|
      begin
        conn.execute(stmt)
      rescue Exception => e
        puts e
      end
    }
  end

  def self.reinstate_specials(conn)
    conn.execute("ALTER TABLE contact_types_contacts ADD CONSTRAINT contact_types_contacts_contact_id_key PRIMARY KEY (contact_id, contact_type_id)")
    create_view( :v_donation_totals,
                 "select d.id, sum(p.amount) from donations as d " +
                 "left outer join payments as p on p.donation_id = d.id " +
                 "group by d.id" ) do |t|
      t.column :id
      t.column :total_paid
    end

    create_view( :v_donations, "select d.*, v.total_paid, " +
                 "CASE WHEN (v.total_paid > d.reported_required_fee) THEN d.reported_required_fee ELSE v.total_paid END, " +
                 "CASE WHEN (v.total_paid < d.reported_required_fee) THEN 0.00 " +
                 "ELSE (v.total_paid - d.reported_required_fee) END " +
                 "from donations as d join v_donation_totals as v on d.id = v.id" ) do |t|
      t.column "id"
      t.column "contact_id"
      t.column "postal_code"
      t.column "reported_required_fee"
      t.column "reported_suggested_fee"
      t.column "txn_complete"
      t.column "txn_completed_at"
      t.column "comments"
      t.column "lock_version"
      t.column "updated_at"
      t.column "created_at"
      t.column "created_by"
      t.column "updated_by"
      t.column "total_paid"
      t.column "fees_paid"
      t.column "donations_paid"
    end
  end

  def self.create_uuid(conn, table, pk)
    begin
      add_column(table, 'temporary_id_field', 'varchar(36)')
      conn.execute "UPDATE #{table} SET temporary_id_field = '#{@@table_counter}_' || #{pk}"
      @@counted_tables[table] = @@table_counter
      @@table_counter += 1
    rescue Exception => e
      puts e
    end
  end

  def self.drop_old_fks(conn, p_table, pk, fkeys)
    fkeys.each {|x|
      f_table, fkey = x.split(".")
      create_fk(conn, p_table, pk, f_table, fkey)
    }
  end

  def self.create_fk(conn, p_table, pk, f_table, fk)
    add_column(f_table, 'temporary_fk_field', 'varchar(36)')
    puts("remapping #{f_table}.#{fk} -> #{p_table}.temporary_id_field")
    conn.execute "UPDATE #{f_table} SET temporary_fk_field = '#{@@counted_tables[p_table]}_' || #{f_table}.#{fk}"
    #(SELECT #{p_table}.temporary_id_field FROM #{p_table} WHERE #{p_table}.#{pk} = #{f_table}.#{fk})"
    remove_column(f_table, fk) # to kill the constraints
    rename_column(f_table, 'temporary_fk_field', fk)
  end

  def self.fix_up_fks(conn, p_table, pk, fkeys)
    begin
      conn.execute "ALTER TABLE #{p_table} DROP CONSTRAINT #{p_table}_pkey"
    rescue Exception => e
      puts e
      conn.execute "DROP index #{p_table}_pkey"
    end
    conn.execute "ALTER TABLE #{p_table} DROP COLUMN id"
    conn.execute "ALTER TABLE #{p_table} RENAME COLUMN temporary_id_field TO id"
    conn.execute "ALTER TABLE #{p_table} ADD CONSTRAINT #{p_table}_pkey PRIMARY KEY (#{pk})"
    fkeys.each {|x|
      f_table, fkey = x.split(".")
      add_foreign_key(f_table, [fk], p_table, [pk], :name => "#{f_table}_#{p_table}_fk")
    }
  end

  def self.up
    # keys={};[CommunityServiceType, ContactMethodType,ContactType,Default,DisbursementType,Disbursement,DiscountSchedule,Donation,GizmoAttr,GizmoContext,GizmoEvent,GizmoTypeattr,GizmoType,PaymentMethod,Payment,Recycling,Sale,VolunteerTaskType,VolunteerTask].each{|t| t.foreign_keys.each {|x| (keys[x.references_table_name] ||= []) << ("#{x.table_name}.#{x.column_names[0]}")}}

    fkeys = {
      "community_service_types"=>["volunteer_tasks.community_service_type_id"],
      "contact_method_types"=>["contact_method_types.parent_id", "contact_methods.contact_method_type_id"],
      "contact_methods"=>[],
      "contact_types" => ["contact_types_contacts.contact_type_id"],
      "contacts"=>["contact_methods.contact_id", "contact_types_contacts.contact_id", "disbursements.contact_id", "donations.contact_id", "sales.contact_id", "volunteer_tasks.contact_id"],
      "defaults"=>[],
      "disbursement_types"=>["disbursements.disbursement_type_id"],
      "disbursements"=>["gizmo_events.disbursement_id"],
      "discount_schedules"=>["discount_schedules_gizmo_types.discount_schedule_id", "sales.discount_schedule_id"],
      "discount_schedules_gizmo_types"=>[],
      "donations"=>["gizmo_events.donation_id", "payments.donation_id"],
      "gizmo_attrs"=>["gizmo_typeattrs.gizmo_attr_id"],
      "gizmo_contexts"=>["gizmo_contexts_gizmo_types.gizmo_context_id", "gizmo_contexts_gizmo_typeattrs.gizmo_context_id", "gizmo_events.gizmo_context_id"],
      "gizmo_events" => ["gizmo_events_gizmo_typeattrs.gizmo_event_id"],
      "gizmo_events_gizmo_typeattrs"=>[],
      "gizmo_typeattrs" => ["gizmo_events_gizmo_typeattrs.gizmo_typeattr_id", "gizmo_contexts_gizmo_typeattrs.gizmo_typeattr_id"],
      "gizmo_types"=>["discount_schedules_gizmo_types.gizmo_type_id", "gizmo_events.gizmo_type_id", "gizmo_contexts_gizmo_types.gizmo_type_id", "gizmo_typeattrs.gizmo_type_id", "gizmo_types.parent_id"],
      "payment_methods"=>["payments.payment_method_id"],
      "payments"=>[],
      "recyclings"=>["gizmo_events.recycling_id"],
      "sales"=>["gizmo_events.sale_id", "payments.sale_id"],
      "volunteer_tasks"=>[],
      "volunteer_task_types"=>["volunteer_task_types.parent_id", "volunteer_tasks.volunteer_task_type_id"],
    }

    conn = Contact.connection

    fix_specials(conn)

    fkeys.keys.each {|table|
      create_uuid(conn, table, "id")
    }

    fkeys.each { |table, keys|
      drop_old_fks(conn, table, "id", keys)
    }

    fkeys.each { |table, keys|
      fix_up_fks(conn, table, "id", keys)
    }

    reinstate_specials(conn)
  end

  def self.down
    # everything should be just fine...
  end
end
