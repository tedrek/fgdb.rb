class GetRidOfAttrs < ActiveRecord::Migration
  def self.up
    add_column 'gizmo_events', 'unit_price_cents', :integer
    add_column 'gizmo_events', 'as_is', :boolean
    add_column 'gizmo_events', 'description', :text
    add_column 'gizmo_events', 'size', :integer

    GizmoEvent.connection.execute("
      update gizmo_events
      set unit_price_cents=(select attr_val_monetary_cents
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='unit_price')
      ")

    GizmoEvent.connection.execute("
      delete from gizmo_events_gizmo_typeattrs
      where gizmo_typeattr_id  in (select gt.id
                                   from gizmo_typeattrs gt
                                        join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                                   where ga.name='description')
            and (attr_val_text = '' or attr_val_text is null);
      ")

    GizmoEvent.connection.execute("
      update gizmo_events
      set description=(select attr_val_text
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='description' limit 1)
      ")

    GizmoEvent.connection.execute("
      update gizmo_events
      set as_is=(select attr_val_boolean
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='as_is')
      ")

    GizmoEvent.connection.execute("
      update gizmo_events set as_is=false where as_is is null
      ")

    GizmoEvent.connection.execute("
      ALTER TABLE gizmo_events ALTER COLUMN as_is SET NOT NULL
      ")

    GizmoEvent.connection.execute("
      update gizmo_events
      set size=(select attr_val_integer
                            from gizmo_events_gizmo_typeattrs gegt
                                 join gizmo_typeattrs gt on gegt.gizmo_typeattr_id=gt.id
                                 join gizmo_attrs ga on gt.gizmo_attr_id=ga.id
                            where gegt.gizmo_event_id=gizmo_events.id
                                  and ga.name='size')
      ")

    GizmoEvent.connection.execute("
      update gizmo_events
      set unit_price_cents=(select suggested_fee_cents
                            from gizmo_types
                            where gizmo_events.gizmo_type_id=gizmo_types.id)
      where gizmo_events.gizmo_context_id = (select id
                                             from gizmo_contexts
                                             where name='donation')
      ")

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

    GizmoEvent.connection.execute("
      update gizmo_events
      set unit_price_cents=adjusted_fee_cents
      where gizmo_events.gizmo_context_id = (select id
                                             from gizmo_contexts
                                             where name='donation')
            and adjusted_fee_cents is not null
      ")


    remove_column 'gizmo_events', 'adjusted_fee_cents'

    drop_table "gizmo_events_gizmo_typeattrs"
    drop_table "gizmo_contexts_gizmo_typeattrs"
    drop_table "gizmo_typeattrs"
    drop_table "gizmo_attrs"
  end

  def self.down
  end
end
