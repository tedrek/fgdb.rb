class DiscountSchedulesGizmoType < ActiveRecord::Base
  usesguid

  belongs_to :gizmo_type
  belongs_to :discount_schedule
end
