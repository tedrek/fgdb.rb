require 'ajax_scaffold'

class GizmoType < ActiveRecord::Base

  def GizmoType.find_all_instantiable
    find( :all,  :conditions => ["instantiable = ?", true] )
  end

end
