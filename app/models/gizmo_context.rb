require 'ajax_scaffold'

class GizmoContext < ActiveRecord::Base
  has_and_belongs_to_many  :gizmo_types
  has_and_belongs_to_many  :gizmo_typeattrs

  def to_s
    name
  end

  def GizmoContext.find_all_for_select
    find(:all).map {|context| [context.name, context.id]}
  end
end
