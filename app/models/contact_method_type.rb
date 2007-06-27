

class ContactMethodType < ActiveRecord::Base
  has_many :contact_methods, :dependent => true
  has_many :contact_method_types, :through => :contact_methods
  acts_as_tree
  # acts_as_userstamp

  def to_s
    description
  end
end
