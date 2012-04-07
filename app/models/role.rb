class Role < ActiveRecord::Base
  validates_uniqueness_of :name
  has_and_belongs_to_many :privileges
  has_and_belongs_to_many "users"

  def privilege_list
    self.privileges.map{|x| x.name + (x.restrict ? '*' : '')}.join(", ")
  end

  def to_privileges
    "role_#{self.name.downcase}"
  end
end
