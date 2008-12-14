class AddRecyclingsRole < ActiveRecord::Migration
  def self.up
    r = Role.new
    r.name = "RECYCLINGS"
    r.save!
  end

  def self.down
  end
end
