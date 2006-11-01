require 'ajax_scaffold'

class GizmoAttr < ActiveRecord::Base
  has_many  :gizmo_typeattrs,
              :dependent => :destroy
  has_many  :gizmo_types,  :through => :gizmo_typeattr

  def to_s
    name
  end

  # for html element ids
  def to_id
    name.downcase.gsub(/[^-_a-z0-9]/, '_')
  end
end
