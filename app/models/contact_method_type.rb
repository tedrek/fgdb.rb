class ContactMethodType < ActiveRecord::Base
  acts_as_tree

  # reversed for organizations
  def self.email_types_ordered
    last = ContactMethodType.find_by_name("email")
    a = last.children
    a = a.sort_by(&:description)
    a.insert(1, last)
    a
  end

  def to_s
    description
  end
end
