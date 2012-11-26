class CreateSkedjulnatorAccesses < ActiveRecord::Migration
  def self.up
    create_table :skedjulnator_accesses do |t|
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :skedjulnator_accesses, :user_id, :users, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :skedjulnator_accesses
  end
end
