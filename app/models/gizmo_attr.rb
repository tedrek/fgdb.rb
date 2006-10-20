require 'ajax_scaffold'

class GizmoAttr < ActiveRecord::Base
  has_many  :gizmo_typeattr
  has_many  :gizmo_type,  :through => :gizmo_typeattr

  def to_s
    name
  end

end
