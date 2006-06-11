class CreateModemCards < ActiveRecord::Migration
  def self.up
    create_table :modem_cards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :modem_cards
  end
end
