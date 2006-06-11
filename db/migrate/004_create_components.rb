class CreateComponents < ActiveRecord::Migration
  def self.up
    create_table :components do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :components
  end
end
