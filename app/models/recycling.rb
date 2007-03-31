class Recycling < ActiveRecord::Base
  include GizmoTransaction
  has_many :gizmo_events, :dependent => :destroy

  def validate
    errors.add_on_empty("gizmo_events")
  end

end
