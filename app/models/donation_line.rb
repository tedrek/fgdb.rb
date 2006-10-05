require 'ajax_scaffold'

class DonationLine < ActiveRecord::Base
  belongs_to  :gizmo_event
  belongs_to  :donation

end
