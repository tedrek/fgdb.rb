class GizmoContext < ActiveRecord::Base
  has_and_belongs_to_many  :gizmo_types
  has_and_belongs_to_many  :gizmo_typeattrs

  def to_s
    name
  end

  def abbrev
    name[0..2].capitalize
  end

  def GizmoContext.find_all_for_select
    find(:all).map {|context| [context.name, context.id]}
  end

  def GizmoContext.donation
    @@donation ||= find_by_name('donation')
  end

  def GizmoContext.sale
    @@sale ||= find_by_name('sale')
  end

  def GizmoContext.disbursement
    @@disbursement ||= find_by_name('disbursement')
  end
  def GizmoContext.recycling
    @@recycling ||= find_by_name('recycling')
  end
end
