class GizmoReturn < ActiveRecord::Base
  define_amount_methods_on("storecredit_difference")
  has_many :gizmo_events, :dependent => :destroy
  has_many :gizmo_types, :through => :gizmo_events

  def gizmo_context
    GizmoContext.gizmo_return
  end
end
