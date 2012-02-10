class CreateSpecSheetQuestions < ActiveRecord::Migration
  def self.up
    create_table :spec_sheet_questions do |t|
      t.string :name
      t.string :question
      t.integer :action_id
      t.integer :type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :spec_sheet_questions
  end
end
