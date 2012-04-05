class Sked < ActiveRecord::Base
  has_and_belongs_to_many :rosters, :list => true, :order => 'position'

  # TODO: FIXME: REMOVE THIS DEBUG STATEMENT
  def category_type
    self.name.match(/(Room|Prebuild)/) ? "Area" : "Program"
  end

  def rosters_s
    self.rosters.map(&:name).sort.join(", ")
  end
end
