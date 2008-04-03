class GizmoEventsGizmoTypeattr < ActiveRecord::Base
  belongs_to  :gizmo_typeattr
  belongs_to  :gizmo_event

  def attr_val_monetary
    attr_val_monetary_cents
  end

  def attr_val_monetary=(something)
    attr_val_monetary_cents=something
  end

  def value
    self.send "attr_val_#{gizmo_typeattr.gizmo_attr.datatype}"
  end

  def value=( val )
    self.send "attr_val_#{gizmo_typeattr.gizmo_attr.datatype}=", val
  end
end
