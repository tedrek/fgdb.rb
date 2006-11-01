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

  def relevant_attrs(context)
    relevant_typeattrs(context).map {|typeattr|
      typeattr.gizmo_attr
    }
  end

  def relevant_typeattrs(context)
    typeattrs = gizmo_typeattrs.select {|typeattr|
      (typeattr.gizmo_contexts.include? context) and
        (typeattr.is_required)
    } || []
    typeattrs += self.parent.relevant_typeattrs(context) if self.parent
    typeattrs
  end

end
