class Sked < ActiveRecord::Base
  has_and_belongs_to_many :rosters, :list => true, :order => 'position'

  def rosters_s
    self.rosters.map(&:name).sort.join(", ")
  end
end
