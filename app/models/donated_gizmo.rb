require 'ajax_scaffold'

class DonatedGizmo < ActiveRecord::Base
  belongs_to :gizmo_type
  belongs_to :donation
end
