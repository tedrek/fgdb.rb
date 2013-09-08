class Sked < ActiveRecord::Base
  has_many :sked_members,
           :dependent => :destroy,
           :order => :position
  has_many :rosters,
           :through => :sked_members,
           :order => 'sked_members.position'

  def to_s
    if self.category_type.to_s.length == 0
      return name
    else
      return name + " (" + self.category_type.to_s + ")"
    end
  end

  def rosters_s
    self.rosters.map(&:name).sort.join(", ")
  end
end
