class CreateDefaultPrivileges < ActiveRecord::Migration
  def self.up
    arr = [
     ["skedjulnator", "role_skedjulnator"],
    ]
    arr.each{|a|
      pn = a.shift
      p = Privilege.new
      p.name = pn
      p.roles = a.map{|x| x.gsub(/^role_/, "").upcase}.map{|x| Role.find_by_name(x)}
      p.save
    }
  end

  def self.down
    Privilege.destroy_all
  end
end
