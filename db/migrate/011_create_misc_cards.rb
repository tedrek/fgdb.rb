class CreateMiscCards < ActiveRecord::Migration
  def self.up
    create_table :misc_cards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :misc_cards
  end
end
