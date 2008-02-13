class GoToUuid < ActiveRecord::Migration
  @@table_counter = 0

  def self.create_uuid(conn, table, pk)
    add_column(table, 'temporary_id_field', 'varchar(36)')
    conn.execute "UPDATE #{table} SET temporary_id_field = '#{@@table_counter}_' || #{pk}"
    @@table_counter += 1
  end

  def self.fix_up_fks(conn, p_table, pk, fkeys)
    fkeys.each {|x|
      f_table, fkey = x.split(".")
      create_fk(conn, p_table, pk, f_table, fkey)
    }
    begin
        conn.execute "ALTER TABLE #{p_table} DROP CONSTRAINT #{p_table}_pkey"
    rescue Exception
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

  def self.create_fk(conn, p_table, pk, f_table, fk)
    add_column(f_table, 'temporary_fk_field', 'varchar(36)')
    puts("remapping #{p_table}.#{pk} #{f_table}.#{fk}")
    conn.execute "UPDATE #{f_table} SET temporary_fk_field =
          (SELECT #{p_table}.temporary_id_field FROM #{p_table} WHERE #{p_table}.#{pk} = #{f_table}.#{fk})"
    remove_column(f_table, fk) # to kill the constraints
    rename_column(f_table, 'temporary_fk_field', fk)
  end

  def self.up
    # keys={};[CommunityServiceType, ContactMethodType,ContactType,Default,DisbursementType,Disbursement,DiscountSchedule,Donation,GizmoAttr,GizmoContext,GizmoEvent,GizmoTypeattr,GizmoType,PaymentMethod,Payment,Recycling,Sale,VolunteerTaskType,VolunteerTask].each{|t| t.foreign_keys.each {|x| (keys[x.references_table_name] ||= []) << ("#{x.table_name}.#{x.column_names[0]}")}}

      fkeys = {
               "community_service_types"=>["volunteer_tasks.community_service_type_id"],
               "contact_method_types"=>["contact_method_types.parent_id", "contact_methods.contact_method_type_id"],
               "contact_types" => ["contact_types_contacts.contact_type_id"],
               "contacts"=>["contact_methods.contact_id", "contact_types_contacts.contact_id", "disbursements.contact_id", "donations.contact_id", "sales.contact_id", "volunteer_tasks.contact_id"],
               "disbursement_types"=>["disbursements.disbursement_type_id"],
               "disbursements"=>["gizmo_events.disbursement_id"],
               "discount_schedules"=>["discount_schedules_gizmo_types.discount_schedule_id", "sales.discount_schedule_id"],
               "donations"=>["gizmo_events.donation_id", "payments.donation_id"],
               "gizmo_attrs"=>["gizmo_typeattrs.gizmo_attr_id"],
               "gizmo_contexts"=>["gizmo_contexts_gizmo_types.gizmo_context_id", "gizmo_contexts_gizmo_typeattrs.gizmo_context_id", "gizmo_events.gizmo_context_id"],
               "gizmo_events" => ["gizmo_events_gizmo_typeattrs.gizmo_event_id"],
               "gizmo_typeattrs" => ["gizmo_events_gizmo_typeattrs.gizmo_typeattr_id", "gizmo_contexts_gizmo_typeattrs.gizmo_typeattr_id"],
               "gizmo_types"=>["discount_schedules_gizmo_types.gizmo_type_id", "gizmo_events.gizmo_type_id", "gizmo_contexts_gizmo_types.gizmo_type_id", "gizmo_typeattrs.gizmo_type_id", "gizmo_types.parent_id"],
               "payment_methods"=>["payments.payment_method_id"],
               "recyclings"=>["gizmo_events.recycling_id"],
               "sales"=>["gizmo_events.sale_id", "payments.sale_id"],
               "volunteer_task_types"=>["volunteer_task_types.parent_id", "volunteer_tasks.volunteer_task_type_id"],
      }

    special = {
      "contact_types_contacts" => 1
    }

    conn = Contact.connection

    conn.execute("ALTER INDEX dispersements_pkey RENAME TO disbursements_pkey")
    conn.execute("ALTER TABLE disbursements DROP CONSTRAINT dispersements_pkey")   
    conn.execute("ALTER INDEX dispersement_types_pkey RENAME TO disbursements_types_pkey")
    conn.execute("DROP INDEX contact_types_contacts_contact_id_key")

    fkeys.keys.each {|table|
      create_uuid(conn, table, "id")
    }

    fkeys.each { |table, keys|
      fix_up_fks(conn, table, "id", keys)
    }

    conn.execute("ALTER TABLE contact_types_contacts ADD CONSTRAINT contact_types_contacts_contact_id_key PRIMARY KEY (contact_id, contact_type_id)")

  end

  def self.down
    # gah!
  end
end
