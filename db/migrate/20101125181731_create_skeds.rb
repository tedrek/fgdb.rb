class CreateSkeds < ActiveRecord::Migration
  def self.up
    create_table :skeds do |t|
      t.string :name

      t.timestamps
    end
    create_table :rosters_skeds, :id => false do |t|
      t.integer :sked_id

      t.integer :roster_id
    end
  end

  def self.down
    drop_table :skeds
    drop_table :rosters_skeds
  end
end
