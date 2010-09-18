class Role < ActiveRecord::Base
  has_and_belongs_to_many "users"

  def to_privileges
    "role_#{self.name.downcase}"
  end
end
