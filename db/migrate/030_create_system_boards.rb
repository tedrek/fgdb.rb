class CreateSystemBoards < ActiveRecord::Migration
  def self.up
    create_table :system_boards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :system_boards
  end
end
