class CreateNetworkCards < ActiveRecord::Migration
  def self.up
    create_table :network_cards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :network_cards
  end
end
