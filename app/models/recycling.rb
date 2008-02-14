class Recycling < ActiveRecord::Base
  usesguid

  include GizmoTransaction
  has_many :gizmo_events, :dependent => :destroy

  def validate
    errors.add_on_empty("gizmo_events")
    errors.add_on_empty("recycled_at", "when?")
  end

end
