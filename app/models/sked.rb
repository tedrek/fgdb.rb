class Sked < ActiveRecord::Base
  has_and_belongs_to_many :rosters, :list => true, :order => 'position'

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
