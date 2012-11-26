class CreateDisciplinaryActionAreas < ActiveRecord::Migration
  def self.up
    create_table :disciplinary_action_areas do |t|
      t.string :name

      t.timestamps
    end

    create_table :disciplinary_action_areas_disciplinary_actions, :id => false do |t|
      t.integer :disciplinary_action_id
      t.integer :disciplinary_action_area_id
    end

    add_foreign_key :disciplinary_action_areas_disciplinary_actions, :disciplinary_action_area_id, :disciplinary_action_areas, :id, :on_delete => :cascade
    add_foreign_key :disciplinary_action_areas_disciplinary_actions, :disciplinary_action_id, :disciplinary_actions, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :disciplinary_action_areas
  end
end
