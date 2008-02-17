class GizmoAttr < ActiveRecord::Base

  has_many  :gizmo_typeattrs,
              :dependent => :destroy
  has_many  :gizmo_types,  :through => :gizmo_typeattrs

  def to_s
    name
  end

end
