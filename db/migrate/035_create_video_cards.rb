class CreateVideoCards < ActiveRecord::Migration
  def self.up
    create_table :video_cards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :video_cards
  end
end
