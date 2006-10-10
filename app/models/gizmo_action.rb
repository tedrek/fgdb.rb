require 'ajax_scaffold'

class GizmoAction < ActiveRecord::Base

  def self.donation
    self.find( :first, :conditions => ['name = ?', 'donation'] )
  end

end
