class GetRidOfAttrs < ActiveRecord::Migration
  def self.up
    add_column 'gizmo_events', 'unit_price_cents', :integer
    add_column 'gizmo_events', 'as_is', :boolean
    add_column 'gizmo_events', 'description', :text
    add_column 'gizmo_events', 'size', :integer

puts "Fixing incorrect gizmo_context_id's"
    GizmoEvent.connection.execute("UPDATE gizmo_events SET gizmo_context_id = 2 WHERE (gizmo_context_id != 2 AND sale_id IS NOT NULL)")
    GizmoEvent.connection.execute("UPDATE gizmo_events SET gizmo_context_id = 1 WHERE (gizmo_context_id != 1 AND donation_id IS NOT NULL)")
    GizmoEvent.connection.execute("UPDATE gizmo_events SET gizmo_context_id = 3 WHERE (gizmo_context_id != 3 AND recycling_id IS NOT NULL)")
    GizmoEvent.connection.execute("UPDATE gizmo_events SET gizmo_context_id = 4 WHERE (gizmo_context_id != 4 AND disbursement_id IS NOT NULL)")

puts "unit_price"
    GizmoEvent.connection.execute("
      update gizmo_events
      set unit_price_cents=(select attr_val_monetary_cents
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='unit_price')
      ")

puts "description"
    GizmoEvent.connection.execute("
      delete from gizmo_events_gizmo_typeattrs
      where gizmo_typeattr_id  in (select gt.id
                                   from gizmo_typeattrs gt
                                        join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                                   where ga.name='description')
            and (attr_val_text = '' or attr_val_text is null);
      ")

puts "description 2"
    GizmoEvent.connection.execute("
      update gizmo_events
      set description=(select attr_val_text
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='description' limit 1)
      ")

puts "as_is"
    GizmoEvent.connection.execute("
      update gizmo_events
      set as_is=(select attr_val_boolean
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='as_is')
      ")

puts "size"
    GizmoEvent.connection.execute("
      update gizmo_events
      set size=(select attr_val_integer
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='size')
      ")

puts "unit_price from suggested_fee"
    GizmoEvent.connection.execute("
      update gizmo_events
      set unit_price_cents=(select suggested_fee_cents
                            from gizmo_types
                            where gizmo_events.gizmo_type_id=gizmo_types.id)
      where gizmo_events.gizmo_context_id = (select id
                                             from gizmo_contexts
                                             where name='donation')
      ")

puts "unit_price from requried_fee"
    GizmoEvent.connection.execute("
      update gizmo_events ge
      set unit_price_cents=gt.required_fee_cents
      from gizmo_types gt
      where gt.required_fee_cents > ge.unit_price_cents
            and ge.gizmo_type_id=gt.id
            and ge.gizmo_context_id = (select id
                                       from gizmo_contexts
                                       where name='donation')
      ")

puts "unit_price from adjusted_fee"
    GizmoEvent.connection.execute("
      update gizmo_events
      set unit_price_cents=adjusted_fee_cents
      where gizmo_events.gizmo_context_id = (select id
                                             from gizmo_contexts
                                             where name='donation')
            and adjusted_fee_cents is not null
            and adjusted_fee_cents != 0
      ")


    puts "unit_price = 0 if NULL"
    GizmoEvent.connection.execute("UPDATE gizmo_events SET unit_price_cents = 0 WHERE sale_id IS NOT NULL and unit_price_cents IS NULL")

    remove_column 'gizmo_events', 'adjusted_fee_cents'

    drop_table "gizmo_events_gizmo_typeattrs"
    drop_table "gizmo_contexts_gizmo_typeattrs"
    drop_table "gizmo_typeattrs"
    drop_table "gizmo_attrs"
  end

  def self.down
  end
end
