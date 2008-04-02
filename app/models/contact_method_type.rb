class ContactMethodType < ActiveRecord::Base
  acts_as_tree

  def to_s
    description
  end
end
