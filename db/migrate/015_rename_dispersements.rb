class RenameDispersements < ActiveRecord::Migration

  def self.rename(conn, from, to)
    ["ALTER INDEX #{from}s_pkey RENAME TO #{to}s_pkey",
     "ALTER INDEX gizmo_events_#{from}_id_index RENAME TO gizmo_events_#{to}_id_index",
     "ALTER TABLE gizmo_events DROP CONSTRAINT gizmo_events_disbursements_fk",
     "ALTER TABLE disbursements DROP CONSTRAINT #{from}s_pkey",
     "ALTER TABLE disbursements ADD CONSTRAINT #{to}s_pkey PRIMARY KEY (id)",
     "ALTER INDEX #{from}_types_pkey RENAME TO #{to}_types_pkey",
     "ALTER TABLE disbursements DROP CONSTRAINT #{from}s_contact_id_fkey",
     "ALTER TABLE disbursements ADD CONSTRAINT #{to}s_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES contacts(id) ON UPDATE CASCADE ON DELETE SET NULL",
     "ALTER TABLE disbursements DROP CONSTRAINT #{from}s_#{from}_type_id_fkey",
     "ALTER TABLE disbursements ADD CONSTRAINT #{to}s_#{to}_type_id_fkey FOREIGN KEY (disbursement_type_id) REFERENCES disbursement_types(id) ON UPDATE CASCADE ON DELETE SET NULL",
     "ALTER TABLE #{from}s_id_seq RENAME TO #{to}s_id_seq",
     "ALTER TABLE #{from}_types_id_seq RENAME TO #{to}_types_id_seq",
    ].each {|stmt|
      begin
        conn.execute(stmt)
      rescue Exception => e
        puts e
      end
    }

    add_foreign_key("gizmo_events", ["disbursement_id"], "disbursements", ["id"], :name => "gizmo_events_disbursements_fk")
  end

  def self.up
    rename(Contact.connection, "dispersement", "disbursement")
  end

  def self.down
    rename(Contact.connection, "disbursement", "dispersement")
  end
end
