class GizmoTypeGroup < ActiveRecord::Base
  has_and_belongs_to_many :gizmo_types

  def gizmo_type_list
    self.gizmo_types.map{|x| x.description}.join(", ")
  end
end
