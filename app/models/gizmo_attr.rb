class GizmoAttr < ActiveRecord::Base
  usesguid

  has_many  :gizmo_typeattrs,
              :dependent => :destroy
  has_many  :gizmo_types,  :through => :gizmo_typeattrs

  def to_s
    name
  end

end
