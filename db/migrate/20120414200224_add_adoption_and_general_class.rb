class AddAdoptionAndGeneralClass < ActiveRecord::Migration
  def self.up
    for i in ["Adoption Classes", "Classes"]
      daa = DisciplinaryActionArea.new(:name => i).save!
    end
  end

  def self.down
  end
end
