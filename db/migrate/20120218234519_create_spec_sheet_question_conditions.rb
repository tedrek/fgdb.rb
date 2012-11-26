class CreateSpecSheetQuestionConditions < ActiveRecord::Migration
  def self.up
    create_table :spec_sheet_question_conditions do |t|
      t.integer :spec_sheet_question_id
      t.string :name
      t.string :operator
      t.string :expected_value

      t.timestamps
    end
    remove_columns :spec_sheet_questions, :action_id
    remove_columns :spec_sheet_questions, :type_id
  end

  def self.down
    drop_table :spec_sheet_question_conditions
  end
end
