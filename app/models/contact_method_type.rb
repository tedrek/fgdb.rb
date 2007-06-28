class ContactMethodType < ActiveRecord::Base
  acts_as_tree
  # acts_as_userstamp

  def to_s
    description
  end
end
