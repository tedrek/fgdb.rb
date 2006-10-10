require 'ajax_scaffold'

class GizmoEvent < ActiveRecord::Base
  has_one :donation
  has_one :sale_txn
  has_one :gizmo_action
end
