require 'ajax_scaffold'

class GizmoContext < ActiveRecord::Base
  has_and_belongs_to_many  :gizmo_type,
              :dependent => :destroy
  has_and_belongs_to_many  :gizmo_typeattr,
              :dependent => :destroy

  def to_s
    name
  end
end
