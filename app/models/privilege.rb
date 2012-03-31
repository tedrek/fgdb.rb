class Privilege < ActiveRecord::Base
  validates_uniqueness_of :name
  has_and_belongs_to_many :roles

  def self.by_name(name)
    Privilege.find_by_name(name) || Privilege.new(:name => name, :restrict => false)
  end

  def children
    ret = []
    if self.name.match(/^role_(.+)$/)
      ret << Role.find_by_name($1.upcase).privileges
    end
    ret
  end
end
