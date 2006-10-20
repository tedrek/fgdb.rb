require 'ajax_scaffold'

class GizmoContext < ActiveRecord::Base
  has_many  :gizmo_contexts_gizmo_type
  has_many  :gizmo_type,  :through => :gizmo_contexts_gizmo_type
  has_many  :gizmo_contexts_gizmo_typeattr
  has_many  :gizmo_typeattr,  :through => :gizmo_contexts_gizmo_typeattr

  def to_s
    name
  end
end
