class CreateSoundCards < ActiveRecord::Migration
  def self.up
    create_table :sound_cards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :sound_cards
  end
end
