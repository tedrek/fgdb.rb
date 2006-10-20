require 'ajax_scaffold'

class GizmoType < ActiveRecord::Base
  acts_as_tree
  has_many  :gizmo_typeattrs,
            :dependent => :destroy
  has_many  :gizmo_attrs,  :through => :gizmo_typeattr

  def to_s
    description
  end

end
