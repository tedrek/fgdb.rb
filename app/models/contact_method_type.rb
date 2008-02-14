class ContactMethodType < ActiveRecord::Base
  usesguid

  acts_as_tree
  # acts_as_userstamp

  def to_s
    description
  end
end
