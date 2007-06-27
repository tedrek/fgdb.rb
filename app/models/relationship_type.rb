

class RelationshipType < ActiveRecord::Base
  # acts_as_userstamp

  def to_s
    description || inspect
  end
end
