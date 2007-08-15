

class VolunteerTaskType < ActiveRecord::Base
  has_many :volunteer_tasks
  acts_as_tree

  def self.root_nodes
    find(:all, :conditions => [ 'parent_id = ?', 0 ])
  end

  def self.find_actual(*ids)
    ids.delete_if {|id| id == 0 }
    find(*ids)
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

  def type_of_task?(type)
    (description == type) ||
      ( parent &&
        parent.type_of_task?(type) )
  end

  def display_name
    parents = ancestors
    parents.pop # get rid of the root node
    if parents.empty?
      description
    else
      parents.reverse!
      "%s (%s)" % [description, parents.map {|type| type.description}.join(":")]
    end
  end

end
