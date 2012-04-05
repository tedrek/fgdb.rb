class AddCategorizationToSchedules < ActiveRecord::Migration
  def self.up
    add_column :skeds, :category_type, :string
    Sked.find(:all).each do |x|
      x.category_type = x.name.match(/Room/) ? "Area" : "Program"
      x.save!
    end
  end

  def self.down
    remove_column :skeds, :category_type
  end
end
