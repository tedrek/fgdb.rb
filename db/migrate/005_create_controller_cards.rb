class CreateControllerCards < ActiveRecord::Migration
  def self.up
    create_table :controller_cards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :controller_cards
  end
end
