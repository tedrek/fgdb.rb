require 'ajax_scaffold'

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
    @@donation ||= find(:first, :conditions => ["name = ?", 'donation'])
  end

  def GizmoContext.sale
    @@sale ||= find(:first, :conditions => ["name = ?", 'sale'])
  end

  def GizmoContext.dispersement
    @@dispersement ||= find(:first, :conditions => ["name = ?", 'dispersement'])
  end
  def GizmoContext.recycling
    @@recycling ||= find(:first, :conditions => ["name = ?", 'recycling'])
  end
end
