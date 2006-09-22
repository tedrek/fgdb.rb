require 'ajax_scaffold'

class VolunteerTaskType < ActiveRecord::Base
  acts_as_tree

  def self.find_all_instantiable
    find(:all, :conditions => [ 'instantiable = ?', true ])
  end

end
