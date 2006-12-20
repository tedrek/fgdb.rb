require 'ajax_scaffold'

class GizmoType < ActiveRecord::Base
  acts_as_tree
  has_many  :gizmo_typeattrs,
            :dependent => :destroy
  has_many  :gizmo_attrs,  :through => :gizmo_typeattr
  has_many  :discount_schedules_gizmo_types,
            :dependent => :destroy
  has_many  :discount_schedules, :through => :discount_schedules_gizmo_types

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
    }
    typeattrs += self.parent.relevant_typeattrs(context) if self.parent
    typeattrs
  end

  def possible_attrs
    possible_typeattrs.map {|typeattr|
      typeattr.gizmo_attr
    }
  end

  def possible_typeattrs
    if parent
      gizmo_typeattrs + parent.possible_typeattrs
    else
      gizmo_typeattrs
    end
  end

  def multiplier_to_apply(schedule)
    schedule.multiplier_for(self) or schedule.multiplier_for(parent) or 1.0
  end

end
