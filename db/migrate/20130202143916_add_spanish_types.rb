class AddSpanishTypes < ActiveRecord::Migration
  def self.up
    for i in [:spanish_build, :spanish_adoption]
      ct = ContactType.new
      ct.for_who = 'per'
      ct.description = i.to_s.sub("_", "")
      ct.name = i
      ct.instantiable = true
      ct.save!
    end
  end

  def self.down
  end
end
