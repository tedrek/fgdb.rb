class DiscountSchedulesGizmoType < ActiveRecord::Base
  belongs_to :gizmo_type
  belongs_to :discount_schedule
end
