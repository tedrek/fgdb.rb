

class GizmoEventsGizmoTypeattr < ActiveRecord::Base
  belongs_to  :gizmo_typeattr
  belongs_to  :gizmo_event

  def value
    self.send "attr_val_#{gizmo_typeattr.gizmo_attr.datatype}"
  end

  def value=( val )
    self.send "attr_val_#{gizmo_typeattr.gizmo_attr.datatype}=", val
  end

end
