class CreateProcessors < ActiveRecord::Migration
  def self.up
    create_table :processors do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :processors
  end
end
