class OhLookAGeneric < ActiveRecord::Migration
  def self.add_it(val)
    if Generic.find_by_value(val)
      return
    end
    g = Generic.new()
    g.value = val
    g.save!
  end

  def self.up
    add_it("0000000000000")
  end

  def self.down
  end
end
