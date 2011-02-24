class Roster < ActiveRecord::Base
  has_and_belongs_to_many :skeds

  def skeds_s
    self.skeds.map(&:name).sort.join(", ")
  end
end
