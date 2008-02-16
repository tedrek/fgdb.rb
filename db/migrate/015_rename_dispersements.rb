class RenameDispersements < ActiveRecord::Migration
  def self.up
    conn = Contact.connection

    ["ALTER INDEX dispersements_pkey RENAME TO disbursements_pkey",
     "ALTER TABLE gizmo_events DROP CONSTRAINT gizmo_events_disbursements_fk",
     "ALTER TABLE disbursements DROP CONSTRAINT dispersements_pkey",
     "ALTER TABLE disbursements ADD CONSTRAINT disbursements_pkey PRIMARY KEY (id)",
     "ALTER INDEX dispersement_types_pkey RENAME TO disbursements_types_pkey",
    ].each {|stmt|
      begin
        conn.execute(stmt)
      rescue Exception => e
        puts e
      end
    }

    add_foreign_key("gizmo_events", ["disbursement_id"], "disbursements", ["id"])
  end

  def self.down
    # everything should be just fine...
  end
end
