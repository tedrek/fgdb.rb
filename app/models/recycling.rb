class Recycling < ActiveRecord::Base
  include GizmoTransaction
  has_many :gizmo_events, :dependent => :destroy, :autosave => :true
  has_many :gizmo_types, :through => :gizmo_events
  acts_as_userstamp

  def gizmo_context
    GizmoContext.recycling
  end

  def validate
    validate_inventory_modifications
    errors.add_on_empty("gizmo_events")
    errors.add_on_empty("recycled_at", "when?")
  end

  before_save :set_occurred_at_on_gizmo_events

  class << self
    def default_sort_sql
      "recycled_at DESC"
    end
  end
end
