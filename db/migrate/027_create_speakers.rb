class CreateSpeakers < ActiveRecord::Migration
  def self.up
    create_table :speakers do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :speakers
  end
end
