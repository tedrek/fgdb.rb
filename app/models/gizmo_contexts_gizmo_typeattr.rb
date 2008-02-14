

class GizmoContextsGizmoTypeattr < ActiveRecord::Base
  usesguid

  belongs_to  :gizmo_context
  belongs_to  :gizmo_typeattr

  def to_s
    "context[#{gizmo_context}]; typeattr[#{gizmo_typeattr}]"
  end

end
