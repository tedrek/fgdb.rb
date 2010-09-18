class Privilege < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def self.by_name(name)
    Privilege.find_by_name(name) || Privilege.new(:name => name)
  end

  def children
    ret = []
    # TODO: role implications support
    if self.name.match(/^role_(.+)$/)
      ret << Role.find_by_name($1.upcase).privileges
    end
    ret
  end
end
