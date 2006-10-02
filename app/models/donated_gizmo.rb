require 'ajax_scaffold'

class DonatedGizmo < ActiveRecord::Base
  belongs_to :gizmo_type
  belongs_to :donation

  def before_save
    gizmo_type = nil if (
      gizmo_type == '---' or gizmo_type == '' or gizmo_type == 0 or gizmo_type == '0'
    )
  end
end
