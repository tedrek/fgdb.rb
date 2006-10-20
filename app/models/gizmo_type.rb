require 'ajax_scaffold'

class GizmoType < ActiveRecord::Base
  acts_as_tree
  has_many  :gizmo_typeattr,
            :dependent => :destroy
  has_many  :gizmo_attr,  :through => :gizmo_typeattr

  def to_s
    description
  end

end
