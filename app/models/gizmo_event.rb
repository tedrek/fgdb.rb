require 'ajax_scaffold'

class GizmoEvent < ActiveRecord::Base
  has_one :donation_line
  # has_one :donation,  :through => :donation_line

end
