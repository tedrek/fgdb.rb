require 'ajax_scaffold'

class GizmoAttr < ActiveRecord::Base
  has_many  :gizmo_typeattr,  
              :dependent => :destroy
  has_many  :gizmo_type,  :through => :gizmo_typeattr

  def to_s
    name
  end

end
