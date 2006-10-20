require 'ajax_scaffold'

class GizmoTypeattr < ActiveRecord::Base
  belongs_to  :gizmo_type
  belongs_to  :gizmo_attr

  has_and_belongs_to_many    :gizmo_contexts

  has_many    :gizmo_events_gizmo_typeattr,
              :dependent => :destroy
  has_many    :gizmo_events, :through => :gizmo_events_gizmo_typeattr

  def to_s
    "id[#{id}]; type[#{gizmo_type_id}]; attr[#{gizmo_attr_id}]"
  end

end
