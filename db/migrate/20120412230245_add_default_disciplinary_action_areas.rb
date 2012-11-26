class AddDefaultDisciplinaryActionAreas < ActiveRecord::Migration
  def self.up
    for i in ["All Areas", "Advanced Testing", "Prebuild", "Build", "Server Build", "Mac Build", "Laptops", "Receiving", "Recycling", "Printerland", "Other (see notes)"]
      daa = DisciplinaryActionArea.new
      daa.name = i
      daa.save!
    end
  end

  def self.down
  end
end
