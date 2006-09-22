require 'ajax_scaffold'

class VolunteerTaskType < ActiveRecord::Base
  acts_as_tree

  def self.find_all_instantiable
    find(:all, :conditions => [ 'instantiable = ?', true ])
  end

  def self.root_nodes
    find(:all, :conditions => [ 'parent_id = ?', 0 ])
  end

  def all_descendants
    all = children + children.map do |child|
      child.all_descendants
    end
    all.flatten
  end

  def all_instantiable_descendants
    kids = self.all_descendants.find_all do |child|
      child.instantiable
    end
    kids.unshift(self) if self.instantiable
    kids
  end

  def self.find_actual(*ids)
    ids.delete_if {|id| id == 0 }
    find(*ids)
  end

end
