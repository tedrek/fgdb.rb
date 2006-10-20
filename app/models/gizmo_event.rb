require 'ajax_scaffold'

class GizmoEvent < ActiveRecord::Base
  has_one :donation
  has_one :sale_txn
  belongs_to  :gizmo_type
  belongs_to  :gizmo_context

  has_many  :gizmo_events_gizmo_typeattr
  has_many  :gizmo_events,  :through => :gizmo_events_gizmo_typeattr

  def to_s
    "id[#{id}]; type[#{gizmo_type_id}]; context[#{gizmo_context_id}]; count[#{gizmo_count}]"
  end
end
