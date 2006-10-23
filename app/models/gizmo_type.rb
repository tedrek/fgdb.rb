require 'ajax_scaffold'

class GizmoType < ActiveRecord::Base
  acts_as_tree
  has_many  :gizmo_typeattrs,
            :dependent => :destroy
  has_many  :gizmo_attrs,  :through => :gizmo_typeattr

  has_and_belongs_to_many    :gizmo_contexts

  validates_numericality_of :required_fee, :suggested_fee

  def to_s
    description
  end

end
